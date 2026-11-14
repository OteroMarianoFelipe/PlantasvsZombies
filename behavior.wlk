import util.config.*
import util.debugger.*
import entityTickingManager.*
import imageProvider.*

class CoolDownTracker{
    var secondsPerUse
    var ticksInCoolDown = 0
    var property slowDownFactor = 1

    method ticksPerUse() = config.secondsToTicks(secondsPerUse * slowDownFactor)
    method coolDown(){ ticksInCoolDown = 0 }
    method tickUp(){ ticksInCoolDown += 1 }

    method slowDown(factor){ slowDownFactor = factor }
    method restoreSpeed(){ slowDownFactor = 1 }

    method ticksUntilUse() = self.ticksPerUse() - ticksInCoolDown 
    method shouldUseStrategy() = self.ticksUntilUse() <= 0
    method shouldAnticipate(animation) = self.ticksUntilUse() == animation.durationInTicks()
}

class Strategy{
    method use(user, state)
    method shouldTick(user) = true
}

class Behavior{
    const property name
    const property strategy
    const property state
    const providerKey

    const coolDownTracker
    method coolDownTracker() = coolDownTracker

    method slowDown(factor){ coolDownTracker.slowDown(factor) }
    method restoreSpeed(){ coolDownTracker.restoreSpeed() }

    method getImageProvider(user){
        if(strategy.shouldTick(user)){
            return user.imageProviderSet().getProvider(providerKey)
            debugger.info("Candidato no nulo en "+name)
        }
        return null
    }

    method tick(user){
        if(strategy.shouldTick(user)){
            coolDownTracker.tickUp()
        }else{
            coolDownTracker.coolDown()
        }
    }

    method tryToUse(user){ 
        if( coolDownTracker.shouldUseStrategy() ){
            coolDownTracker.coolDown()
            strategy.use(user, state)
        }
    }
}

class AnticipatedBehavior inherits Behavior{
    override method tryToUse(user){
        super(user)
        const providerForAnticipation = user.imageProviderSet().getProvider(providerKey)
        if( coolDownTracker.shouldAnticipate(providerForAnticipation) ){
            user.anticipateBehavior( providerForAnticipation )
        }
    }
}

object movingStrategy inherits Strategy(){
    method newPosition(user, state) = user.position().right(state.movingDirection().x()).up(state.movingDirection().y())

    method allObstacles(user) = user.allCollidingEntities().filter({ e => user.isEnemy(e) && e.blocksEnemyEntitiesMovement()})
    method hasObstacle(user) = self.allObstacles(user).size() > 0

    override method shouldTick(user) = not self.hasObstacle(user)

    override method use(user, state){
        const newPosition = self.newPosition(user, state)
        user.position(newPosition)
        if(not config.isInGardenBounds(user.position())){
            user.outOfBounds()
        }
    }
}

object meleeAttackStrategy inherits Strategy(){
    method getFirstMeleeAttackObjective(user) = 
        user.allCollidingEntities().findOrDefault({ e => user.isEnemy(e) && e.canBeKilled() }, null)

    method hasAttackTarget(user) = self.getFirstMeleeAttackObjective(user) != null

    override method shouldTick(user) = self.hasAttackTarget(user)

    override method use(user, state){
        self.getFirstMeleeAttackObjective(user).takeDamage(state.damage())
    }
}

class ShootingStrategy inherits Strategy{
    override method use(user, state){
        const newProyectile = state.proyectileGenerator().apply(user)
        newProyectile.start(user.position())
    }
}

object unconditionalShootingStrategy inherits ShootingStrategy{}

object conditionalShootingStrategy inherits ShootingStrategy{
    method allEnemiesInLineOfSight(user) = 
        user.allEntitiesAtOwnLine().filter({ e => user.isEnemy(e) && e.canBeKilled()})

    method hasTarget(user) = 
        self.allEnemiesInLineOfSight(user).size() > 0
        
    override method shouldTick(user) = self.hasTarget(user)
}