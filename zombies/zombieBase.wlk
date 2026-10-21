import assets.zombie.*
import entidadViva.*
import plantas.planta.*
import entityManager.*
import player.*
import util.config.*

class ZombieBase inherits EntidadViva{
  var property healthStage = 0

  var property objetivoDeAtaque = null
  var property frozen = 0
  var property freezeTick = false
  var property ticksHastaAvance = self.ticksPerCell()
  var property ticksHastaAtaque = self.ticksPerAttack()

  var property currentBehavior = { => self.move() }
  
  const property danio = self.danioMordida() 

  override method team() = "ZOMBIES"

  // Devuelven una lista de tres animaciónes de más vida a menos vida
  method deathAnimation()
  method walkingAnimations()
  method eatingAnimations()
  method currentWalkingAnimation() = self.walkingAnimations().get(healthStage)
  method currentEatingAnimation() = self.eatingAnimations().get(healthStage)
  
  method damageThresholds() = [self.startingHealth()*2/3, self.startingHealth()*1/3, 0]
  method isBelowCurrentThreshold() = health < self.damageThresholds().get(healthStage)

  method invertFreezeTick(){ freezeTick = not freezeTick }
  method freeze(){ self.frozen(config.secondsToTicks(10)) }

  override method start(pos){
    self.changeDefaultAnimation(self.currentWalkingAnimation())
    super(pos)
  }

  override method takeDamage(damage){
    super(damage)
    if( self.isBelowCurrentThreshold() and self.lives()){
      healthStage+=1
      self.changeDefaultAnimation(self.currentWalkingAnimation())
      var animationToUse = null
      if(objetivoDeAtaque == null){
        animationToUse = self.currentWalkingAnimation()
      }else{
        animationToUse = self.currentEatingAnimation()
      }
      animationHandler.changeAnimationSeamlessly(animationToUse)
    }   
  }

  method danioMordida()
  method secondsPerCell()
  method secondsPerAttack()
  method ticksPerCell() = config.secondsToTicks(self.secondsPerCell())
  method ticksPerAttack() = config.secondsToTicks(self.secondsPerAttack())

  method changeToAttackMode(entity){
    self.objetivoDeAtaque(entity)
    animationHandler.changeAnimation(self.currentEatingAnimation())
    self.currentBehavior({ => self.attack()})
    self.coolDownAtaque()
  }
  method changeToMoveMode(){
    self.objetivoDeAtaque(null)
    self.useDefaultAnimation()
    self.currentBehavior({ => self.move()})
    self.coolDownAvance()
  }

  method collisionHandler(otherEntity){
    // Si es planta ataca a la entidad, caso contrario la ignora
    if(otherEntity.team()==self.team() or otherEntity.team()=="NEUTRAL") {return}
    if(not self.tieneObjetivo() and otherEntity.canBeKilled()){
      self.changeToAttackMode(otherEntity)
    }
    return
  }
  method handleCollitions(){
    const intersectantes = entityManager.allIntersectingEntities(self)
    intersectantes.forEach({entity => self.collisionHandler(entity) })
  }

  method crossedTheYard() = position.x() < config.lowerBound().x()

  method coolDownAvance(){ ticksHastaAvance = self.ticksPerCell() }
  method reducirCoolDownDeAvanze(){ ticksHastaAvance -= 1 }
  method coolDownAtaque() { ticksHastaAtaque = self.ticksPerAttack() }
  method reducirCoolDownDeAtaque(){ ticksHastaAtaque -= 1 }
  method tieneObjetivo() = self.objetivoDeAtaque() != null

  method move() { 
    if(self.ticksHastaAvance()!=0){
      self.reducirCoolDownDeAvanze()
    }else{
      self.position(position.left(1) )
      self.updateMapPosition()
      self.coolDownAvance()
      if(self.crossedTheYard()){
        self.cleanUp()
      }
    }
    self.updateMapPosition()
  }
  method attack() {
    if(self.ticksHastaAtaque() == 0){
      self.objetivoDeAtaque().takeDamage(danio)
      self.coolDownAtaque()
    }else{
      self.reducirCoolDownDeAtaque()
    }
    if(not self.objetivoDeAtaque().lives()){ 
      self.changeToMoveMode()
    }
  }

  override method tick(){
    self.handleCollitions()
    if(frozen>0){
      frozen-=1
      self.invertFreezeTick()
      if(freezeTick){ return }
    }
    currentBehavior.apply()
    return
  }

  override method handleOwnRemoval(){
    currentBehavior = { => }
    animationHandler.changeAnimation(self.deathAnimation(), { => self.cleanUp()})
    entityManager.removeEntityCollitions(self)
  }
}
