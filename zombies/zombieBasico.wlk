import zombie.*
import entity.*
import assets.zombie.*
import imageProvider.*

class ZombieBasico inherits Zombie(
    startingHealth = 190,
    imageProviderSet = new BasicZombieImageProvidersSet(),
    defaultImageProvider = imageProviderSet.walkingImageProvider(),
    deathHandler = defaultZombieDeathHandler,
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

class BasicZombieImageProvidersSet inherits ZombieImageProviderSet(
    walkingImageProvider = new HealthBasedImageProvider( 
        imageProviderSet=[
            new ZombieWalkingDying(),
            new ZombieWalkingHurt(),
            new ZombieWalkingFH()
        ]
    ),
    eatingImageProvider = new HealthBasedImageProvider(
        imageProviderSet=[
            new ZombieEatingDying(),
            new ZombieEatingHurt(),
            new ZombieEatingFH()
        ]
    ),
    deathAnimation = new ZombieDeath()
){} 