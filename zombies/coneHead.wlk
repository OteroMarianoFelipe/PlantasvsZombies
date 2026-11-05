import imageProvider.*
import entity.*
import assets.zombies.*
import zombies.zombie.*
import zombies.zombieBasico.*
import entityManager.*

class ConeHead inherits Zombie(
    maxHealth = 370,
    imageProviderSet = new ConeHeadImageProvidersSet(),
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

class ConeHeadImageProvidersSet inherits ZombieImageProviderSet(
    walkingImageProvider = new HealthBasedImageProvider(
        imageProviderSet = [
            new ConeHeadWalkingDying(),
            new ConeHeadWalkingHurt(),
            new ConeHeadWalkingFH()
        ]
    ),
    eatingImageProvider = new HealthBasedImageProvider(
        imageProviderSet = [
            new ConeHeadEatingDying(),
            new ConeHeadEatingHurt(),
            new ConeHeadEatingFH()
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
        user.imageProviderSet( new BasicZombieImageProvidersSet() )
    }

    method apply(user){
        self.changeUsersHealth(user)
        self.changeUsersImageProviderSet(user)
        user.deathHandler(defaultZombieDeathHandler)
    }
}