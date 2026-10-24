import util.config.*
import entityManager.*
import animation.*

class Behavior{
    var property secondsPerUse

    method activate(user)
    
    var property ticksInCoolDown = 0
    var property anticipationAnimation = noImageProvider

    method ticksPerUse() = config.secondsToTicks(secondsPerUse)
    method coolDownBehavior(){ self.ticksInCoolDown(0) }
    method tickUpInCoolDownTime(){ ticksInCoolDown += 1 }

    method use(user){
        const ticksUntilUse = self.ticksPerUse() - ticksInCoolDown 
        if( ticksUntilUse == 0 ){
            self.activate(user)
            self.coolDownBehavior()
        }else{
            if( ticksUntilUse == anticipationAnimation.durationInTicks() ){
                user.anticipateBehavior()
            }
            self.tickUpInCoolDownTime()
        }
    }
}

class MovingBehavior inherits Behavior{
    var property movingDirection

    method newPosition(user) = user.position().right(movingDirection.x()).up(movingDirection.y())

    override method activate(user){
        const newPosition = self.newPosition(user)
        user.updatePosition(newPosition)
    }
}

class MeleeAttackBehavior inherits Behavior{
    override method use(user){
        super(user)
        if(not user.objetivoDeAtaque().lives()){ 
            user.targetEliminated()
        }
    }

    override method activate(user){
        user.objetivoDeAtaque().takeDamage(user.meleeDamage())
    }
}

class ShootingBehavior inherits Behavior{
    var property createNewProyectileInstance

    override method activate(user){
        const newProyectile = createNewProyectileInstance.apply(user)
        entityManager.addEntity(newProyectile, user.position())
    }
}

object noBehavior  { method use(user){} }