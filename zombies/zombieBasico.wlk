import zombie.*
import entity.*
import imageProvider.*
import actionModule.*
import behavior.*

class ZombieBasico inherits Zombie(
    maxHealth = 270,
    deathHandler = defaultZombieDeathHandler,
    imageProviderSet = new BasicZombieImageProvider(),
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
                    providerKey = "#MeleeAttack",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 1 ),
                    state = object{ var property damage = 100},
                    strategy = meleeAttackStrategy
                )
            }
        ){}    
){}

class BasicZombieImageProvider inherits ImageProviderSet{
    method initialize() = 
        self.initialize([
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
        ])
}

object zombieWalkingDying inherits Sprite(image = "animations/zombies/basic/walking/dying.gif"){}
object zombieWalkingHurt inherits Sprite(image = "animations/zombies/basic/walking/hurt.gif"){}
object zombieWalkingFH inherits Sprite(image = "animations/zombies/basic/walking/fullHealth.gif"){}

object zombieEatingDying inherits Sprite(image = "animations/zombies/basic/eating/dying.gif"){}
object zombieEatingHurt inherits Sprite(image = "animations/zombies/basic/eating/hurt.gif"){}
object zombieEatingFH inherits Sprite(image = "animations/zombies/basic/eating/fullHealth.gif"){}

object zombieDying inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "zombies/basic/death"){}