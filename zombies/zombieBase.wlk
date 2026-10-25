import assets.zombie.*
import entidadViva.*
import plantas.planta.*
import entityManager.*
import player.*
import util.config.*
import UIElements.gameOver.*
import behavior.*
import stateMachine.*
import util.debugger.*

class ZombieBase inherits EntidadViva(blocksOwnCell = false, team = "ZOMBIES", startingHealth = statBlock.startingHealth()){
    var property statBlock
    var property behaviorStateMachine
    var property imageProviderSet
    var property deathHandler
    var property collitionBehavior

    var property objetivoDeAtaque = null
    var property frozen = 0
    var property freezeTick = false

    method meleeDamage() = statBlock.meleeDamage()
    method rangedDamage() = statBlock.rangedDamage()
    method secondsPerCell() = statBlock.secondsPerCell()
    method secondsPerAttack() = statBlock.secondsPerAttack()

    method hasAttackTarget() = objetivoDeAtaque != null

    method newAttackTarget(newTarget){
        self.objetivoDeAtaque(newTarget)
        self.changeImageProvider(imageProviderSet.eatingImageProvider()) 
    }

    method targetEliminated(){
        self.objetivoDeAtaque(null)
        self.changeImageProvider(imageProviderSet.walkingImageProvider())
    }

    method invertFreezeTick(){ freezeTick = not freezeTick }
    method freeze(){ self.frozen(config.secondsToTicks(10)) }

    method collisionHandler(otherEntity){
        // Si es planta ataca a la entidad, caso contrario la ignora
        if(otherEntity.team()==self.team() or otherEntity.team()=="NEUTRAL") {return}
        if(not self.hasAttackTarget() and otherEntity.canBeKilled()){
            self.newAttackTarget(otherEntity)
        }
        return
    }
    method handleCollitions(){
        const intersectantes = entityManager.allIntersectingEntities(self)
        intersectantes.forEach({entity => self.collisionHandler(entity) })
    }
  
    method crossedTheYard() = position.x() < config.lowerBound().x()
  
    override method tick(){
        collitionBehavior.use(self)
        // if(frozen>0){
        //   frozen-=1
        //   self.invertFreezeTick()
        //   if(freezeTick){ return }
        // }
        behaviorStateMachine.evaluateAlternatives(self)
        behaviorStateMachine.use(self)
        return
    }

    override method updatePosition(newPosition){
        super(newPosition)
        if(self.crossedTheYard()){
            gameOver.trigger()
            self.cleanUp()
        }
    }

    method updateDeathHandler(){ deathHandler.evaluateAlternatives(self) }
    override method handleDeath(){ deathHandler.use(self) }
}

class ZombieImageProviderSet{
    var property walkingImageProvider
    var property eatingImageProvider
    var property deathAnimation
}

class ZombieStatBlock{
    var property startingHealth
    var property meleeDamage
    var property rangedDamage
    var property secondsPerCell
    var property secondsPerAttack
}

class ZombieDeathBehaviorState inherits BehavioralState(
    paths = [],
    behaviors = []
){}

class DefaultZombieAttackBehaviorState inherits BehavioralState(
    paths = [
        new Path(
            proposedState = new DefaultZombieMovementBehaviorState(),
            condition = { user => not user.hasAttackTarget() }
        )
    ],
    behaviors = [ 
        new MeleeAttackBehavior(
            secondsPerUse = 1 
        ) 
    ]
){}

class DefaultZombieMovementBehaviorState inherits BehavioralState(
    paths = [
        new Path(
            proposedState = new DefaultZombieAttackBehaviorState(),
            condition = { user => user.hasAttackTarget() }
        )
    ],
    behaviors = [ 
        new MovingBehavior(
            secondsPerUse = 4.7,
            movingDirection = game.at(-1, 0)
        ) 
    ]
){}

class DefaultZombieDeath inherits State(
    paths = []
){
    override method use(user){
        user.behaviorStateMachine().forceStateChange(new ZombieDeathBehaviorState())
        user.animationCallback({ => user.cleanUp()}) 
        user.changeImageProvider(user.imageProviderSet().deathAnimation())
        entityManager.removeEntityCollitions(user)
    }
}