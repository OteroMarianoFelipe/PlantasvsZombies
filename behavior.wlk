import util.config.*
import entityManager.*
import imageProvider.*

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
                user.anticipateBehavior(self.anticipationAnimation())
            }
            self.tickUpInCoolDownTime()
        }
    }
}

class CollitionBehavior inherits Behavior( secondsPerUse=0 ){
    override method activate(user){
        const intersectantes = entitiesMap.allIntersectingEntities(user)
        intersectantes.forEach({ e => user.collisionHandler(e)})
    }
}

class MovingBehavior inherits Behavior{
    var property movingDirection

    method inBounds(user) = user.position().x() <= game.width()-1
    method newPosition(user) = user.position().right(movingDirection.x()).up(movingDirection.y())

    override method activate(user){
        const newPosition = self.newPosition(user)
        user.updatePosition(newPosition)
        if(not self.inBounds(user)){
            user.cleanUp()
        }
    }
}

class MeleeAttackBehavior inherits Behavior{
    var property damage
    var property objective = null

    override method activate(user){
        objective.takeDamage(damage)
    }
}

class ShootingBehavior inherits Behavior{
    var property createNewProyectileInstance

    override method activate(user){
        const newProyectile = createNewProyectileInstance.apply(user)
        newProyectile.start(user.position())
    }
}

object noBehavior  { method use(user){} }