import imageProvider.*
import entity.*
import zombies.zombie.*
import zombies.zombieBasico.*
import entityTickingManager.*
import actionModule.*

class ConeHead inherits Zombie(
    maxHealth = 370,
    imageProviderSet = coneHeadImageProvidersSet,
    defaultImageProvider = imageProviderSet.walkingImageProvider(),
    deathHandler = coneHeadDeathHandler,
    actionModule = { caller =>
        object inherits Mobile(
            cellsPerSecond = 1/4.7,
            movingDirection = game.at(-1, 0)
        ) and MeleeAttack(
            meleeDamage = 100,
            meleeAttacksPerSecond = 1
        ) and ActionModule{}
    }.apply(self)
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