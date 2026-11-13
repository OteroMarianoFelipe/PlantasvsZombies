import imageProvider.*
import entity.*
import zombies.zombie.*
import zombies.zombieBasico.*
import entityTickingManager.*
import actionModule.*
import behavior.*

class ConeHead inherits Zombie(
    maxHealth = 370,
    imageProviderSet = coneHeadImageProvidersSet,
    defaultImageProvider = imageProviderSet.walkingImageProvider(),
    deathHandler = coneHeadDeathHandler,
    actionModule = 
        new ActionModule(
            behaviors = #{
                new Behavior(
                    name = "#Movement",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 4.7 ),
                    state = object{ var property movingDirection = game.at(-1, 0) },
                    strategy = movingStrategy
                ),
                new Behavior(
                    name = "#MeleeAttack",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 1 ),
                    state = object{ var property damage = 100},
                    strategy = meleeAttackStrategy
                )
            }
        )
){}

object coneHeadImageProvidersSet inherits ZombieImageProviderSet(
    walkingImageProvider = new HealthBasedImageProvider(
        imageProviderSet = [
            coneHeadWalkingDying,
            coneHeadWalkingHurt,
            coneHeadWalkingFH
        ]
    ),
    eatingImageProvider = new HealthBasedImageProvider(
        imageProviderSet = [
            coneHeadEatingDying,
            coneHeadEatingHurt,
            coneHeadEatingFH
        ]
    ),
    deathAnimation = noImageProvider
){} 

object coneHeadDeathHandler{
    method changeUsersHealth(user){
        user.maxHealth(190)
        user.health(190)
    }
    method changeUsersImageProviderSet(user){
        user.imageProviderSet( basicZombieImageProvidersSet )
    }

    method apply(user){
        self.changeUsersHealth(user)
        self.changeUsersImageProviderSet(user)
        user.deathHandler(defaultZombieDeathHandler)
    }
}

object coneHeadWalkingDying inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/coneHead/walkingDying"){}
object coneHeadWalkingHurt inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/coneHead/walkingHurt"){}
object coneHeadWalkingFH inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/coneHead/walkingFH"){}

object coneHeadEatingDying inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/coneHead/eatingDying"){}
object coneHeadEatingHurt inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/coneHead/eatingHurt"){}
object coneHeadEatingFH inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/coneHead/eatingFH"){}