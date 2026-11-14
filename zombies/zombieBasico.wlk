import zombie.*
import entity.*
import imageProvider.*
import actionModule.*
import behavior.*

class ZombieBasico inherits Zombie(
    maxHealth = 190,
    deathHandler = defaultZombieDeathHandler,
    imageProviderSet = basicZombieImageProvidersSet,
    defaultImageProviderKey = "#Moving",
    actionModule = 
        object inherits ActionModule(
            behaviors = #{
                new Behavior(
                    name = "#Movement",
                    providerKey = "#Moving",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 4.7 ),
                    state = object{ var property movingDirection = game.at(-1, 0) },
                    strategy = movingStrategy
                ),
                new Behavior(
                    name = "#MeleeAttack",
                    providerKey = "#MeleeAttacking",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 1 ),
                    state = object{ var property damage = 100},
                    strategy = meleeAttackStrategy
                )
            }
        ){}    
){}

object basicZombieImageProvidersSet inherits ImageProviderSet(
    entries = #{
        new KeyProviderPair(
            key = "#Moving",
            provider =
                new HealthBasedImageProvider( 
                    imageProviderSet=[
                        zombieWalkingDying,
                        zombieWalkingHurt,
                        zombieWalkingFH
                    ]
                )
        ),
        new KeyProviderPair(
            key = "#MeleeAttack",
            provider =
                new HealthBasedImageProvider(
                    imageProviderSet=[
                        zombieEatingDying,
                        zombieEatingHurt,
                        zombieEatingFH
                    ]
                )
        ),
        new KeyProviderPair(
            key = "#Death",
            provider = zombieDying
        )
    }
){} 

object zombieWalkingDying inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/walkingDying"){}
object zombieWalkingHurt inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/walkingHurt"){}
object zombieWalkingFH inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/walkingFH"){}

object zombieEatingDying inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/eatingDying"){}
object zombieEatingHurt inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/eatingHurt"){}
object zombieEatingFH inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/eatingFH"){}

object zombieDying inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "zombies/basic/death"){}