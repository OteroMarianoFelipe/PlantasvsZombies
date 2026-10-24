import assets.zombie.*
import entidadViva.*
import plantas.planta.*
import entityManager.*
import player.*
import util.config.*
import UIElements.gameOver.*
import behavior.*

class ZombieBase inherits EntidadViva(blocksOwnCell = false, team = "ZOMBIES"){
    var property meleeDamage
    var property rangedDamage
    var property secondsPerMove
    var property secondsPerAttack

    var property healthStage = 0
    var property objetivoDeAtaque = null
    var property frozen = 0
    var property freezeTick = false

    method ticksPerMove() = config.secondsToTicks(secondsPerMove)
    method ticksPerAttack() = config.secondsToTicks(secondsPerAttack)

    var property currentBehavior = new MovingBehavior( secondsPerUse = 4.7, movingDirection = game.at(-1, 0) )

    // Devuelven una lista de tres animaciónes de más vida a menos vida
    method deathAnimation()
    method walkingAnimations()
    method eatingAnimations()

    method newAttackTarget(newTarget){
        self.objetivoDeAtaque(newTarget)
        self.currentBehavior( new MeleeAttackBehavior( secondsPerUse = 1 ) )
        animationHandler.changeImageProvider(self.currentEatingAnimation()) 
    }

    method targetEliminated(){
        self.objetivoDeAtaque(null)
        self.useDefaultImageProvider()
        self.currentBehavior( new MovingBehavior(secondsPerUse = 4.7, movingDirection = game.at(-1, 0)) )
    }

    method currentWalkingAnimation() = self.walkingAnimations().get(healthStage)
    method currentEatingAnimation() = self.eatingAnimations().get(healthStage)
    
    method damageThresholds() = [self.startingHealth()*2/3, self.startingHealth()*1/3, 0]
    method isBelowCurrentThreshold() = health < self.damageThresholds().get(healthStage)

    method invertFreezeTick(){ freezeTick = not freezeTick }
    method freeze(){ self.frozen(config.secondsToTicks(10)) }

    override method start(pos){
        self.changeDefaultImageProvider(self.currentWalkingAnimation())
        super(pos)
    }

    override method takeDamage(incomingDamage){
        super(incomingDamage)
        if( self.isBelowCurrentThreshold() and self.lives()){
            healthStage+=1
            self.changeDefaultImageProvider(self.currentWalkingAnimation())
            var animationToUse = null
            if(objetivoDeAtaque == null){
                animationToUse = self.currentWalkingAnimation()
            }else{
                animationToUse = self.currentEatingAnimation()
            }
            animationHandler.changeImageProviderSeamlessly(animationToUse)
        }   
    }

    method collisionHandler(otherEntity){
        // Si es planta ataca a la entidad, caso contrario la ignora
        if(otherEntity.team()==self.team() or otherEntity.team()=="NEUTRAL") {return}
        if(not self.tieneObjetivo() and otherEntity.canBeKilled()){
            self.newAttackTarget(otherEntity)
        }
        return
    }
    method handleCollitions(){
        const intersectantes = entityManager.allIntersectingEntities(self)
        intersectantes.forEach({entity => self.collisionHandler(entity) })
    }
  
    method crossedTheYard() = position.x() < config.lowerBound().x()

    method tieneObjetivo() = self.objetivoDeAtaque() != null
  
    override method tick(){
        self.handleCollitions()
        // if(frozen>0){
        //   frozen-=1
        //   self.invertFreezeTick()
        //   if(freezeTick){ return }
        // }
        currentBehavior.use(self)
        return
    }

    override method updatePosition(newPosition){
        super(newPosition)
        if(self.crossedTheYard()){
            gameOver.trigger()
            self.cleanUp()
        }
    }

    override method handleDeath(){
        currentBehavior = noBehavior
        animationHandler.changeImageProvider(self.deathAnimation(), { => self.cleanUp()})
        entityManager.removeEntityCollitions(self)
    }
}
