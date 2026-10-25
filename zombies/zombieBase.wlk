import assets.zombie.*
import entidadViva.*
import plantas.planta.*
import entityManager.*
import player.*
import util.config.*
import UIElements.gameOver.*
import behavior.*
import stateMachine.*

class ZombieBase inherits EntidadViva(blocksOwnCell = false, team = "ZOMBIES"){
    var property meleeDamage
    var property rangedDamage
    var property secondsPerCell
    var property secondsPerAttack
    var property behaviorStateMachine
    var property walkingImageProvider
    var property eatingImageProvider
    var property deathAnimation

    var property healthStage = 0
    var property objetivoDeAtaque = null
    var property frozen = 0
    var property freezeTick = false

    method hasAttackTarget() = objetivoDeAtaque != null

    method newAttackTarget(newTarget){
        self.objetivoDeAtaque(newTarget)
        self.changeImageProvider(eatingImageProvider) 
    }

    method targetEliminated(){
        self.objetivoDeAtaque(null)
        self.changeImageProvider(walkingImageProvider)
    }

    method invertFreezeTick(){ freezeTick = not freezeTick }
    method freeze(){ self.frozen(config.secondsToTicks(10)) }

    override method start(pos){
        self.changeDefaultImageProvider(walkingImageProvider)
        super(pos)
    }

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
        self.handleCollitions()
        // if(frozen>0){
        //   frozen-=1
        //   self.invertFreezeTick()
        //   if(freezeTick){ return }
        // }
        // currentBehavior.use(self)
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

    override method handleDeath(){
        behaviorStateMachine.forceStateChange(new ZombieDeathBehaviorState())
        animationCallback = { => self.cleanUp()} 
        self.changeImageProvider(self.deathAnimation())
        entityManager.removeEntityCollitions(self)
    }
}

////////////////////////////////////////////////////////////////////////////
//                         ZOMBIES BEHAVIOR STATES                        //
////////////////////////////////////////////////////////////////////////////

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