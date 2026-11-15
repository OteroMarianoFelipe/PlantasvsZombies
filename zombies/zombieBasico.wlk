import zombie.*
import entity.*
import imageProvider.*
import actionModule.*
import behavior.*

class ZombieBasico inherits Zombie(
    maxHealth = 190,
    deathHandler = defaultZombieDeathHandler,
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(
                key = "#Moving",
                value =
                    new HealthBasedImageProvider( 
                        imageProviderSet=[
                            zombieWalkingDying,
                            zombieWalkingHurt,
                            zombieWalkingFH
                        ]
                    )
            ),
            new ImageProviderEntry(
                key = "#MeleeAttack",
                value =
                    new HealthBasedImageProvider(
                        imageProviderSet=[
                            zombieEatingDying,
                            zombieEatingHurt,
                            zombieEatingFH
                        ]
                    )
            ),
            new ImageProviderEntry(
                key = "#Death",
                value = zombieDying
            )
        ]),
    defaultImageProviderKey = "#Moving",
    actionModule = 
        object inherits ActionModule(
            behaviors = #{
                new Behavior(
                    key = "#Movement",
                    providerKey = "#Moving",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 4.7 ),
                    state = object{ var property movingDirection = game.at(-1, 0) },
                    strategy = movingStrategy
                ),
                new Behavior(
                    key = "#MeleeAttack",
                    providerKey = "#MeleeAttacking",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 1 ),
                    state = object{ var property damage = 100},
                    strategy = meleeAttackStrategy
                )
            }
        ){}    
){}

object zombieWalkingDying inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/walking/dying"){}
object zombieWalkingHurt inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/walking/hurt"){}
object zombieWalkingFH inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/walking/FH"){}

object zombieEatingDying inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/eating/dying"){}
object zombieEatingHurt inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/eating/hurt"){}
object zombieEatingFH inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/basic/eating/FH"){}

object zombieDying inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "zombies/basic/death"){}