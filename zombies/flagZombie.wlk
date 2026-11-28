import zombie.*
import entity.*
import imageProvider.*
import actionModule.*
import behavior.*

class FlagZombie inherits Zombie(
    maxHealth = 200,
    imageProviderSet = new FlagZombieImageProvider(),
    defaultImageProviderKey = "#Moving",
    actionModule = 
        object inherits ActionModule(
            behaviors = #{
                new Behavior(
                    key = "#Movement",
                    providerKey = "#Moving",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 3.13 ),
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
        ){},
        thresholdHandler = new FlagZombieHealthThresholds()
){}

class FlagZombieHealthThresholds inherits HealthThreshold(
    thresholds = [
        new Threshold(
            change = { user => 
                const imgProvSet = user.imageProviderSet()
                imgProvSet.add("#Walking", flagZombieWalkingHurt)
                imgProvSet.add("#MeleeAttack", flagZombieEatingHurt)
            },
            condition = new AmountCondition( amount = 135 )
        ),
        new Threshold(
            change = { user => 
                const imgProvSet = user.imageProviderSet()
                imgProvSet.add("#Walking", zombieWalkingDying)
                imgProvSet.add("#MeleeAttack", zombieEatingDying)
            },
            condition = new AmountCondition( amount = 20 )
        )
    ]
){}

class FlagZombieImageProvider inherits ImageProviderSet{
    method initialize() = 
        self.initialize([
            new ImageProviderEntry(
                key = "#Moving",
                value = flagZombieWalkingFH
            ),
            new ImageProviderEntry(
                key = "#MeleeAttack",
                value = flagZombieEatingFH
            ),
            new ImageProviderEntry(
                key = "#Death",
                value = zombieDying
            )
        ])
}

object zombieWalkingDying inherits Sprite(image = "animations/zombies/basic/walking/dying.gif"){}
object flagZombieWalkingHurt inherits Sprite(image = "animations/zombies/flagZombie/walking/hurt.gif"){}
object flagZombieWalkingFH inherits Sprite(image = "animations/zombies/flagZombie/walking/fullHealth.gif"){}

object zombieEatingDying inherits Sprite(image = "animations/zombies/basic/eating/dying.gif"){}
object flagZombieEatingHurt inherits Sprite(image = "animations/zombies/flagZombie/eating/hurt.gif"){}
object flagZombieEatingFH inherits Sprite(image = "animations/zombies/flagZombie/eating/fullHealth.gif"){}

object zombieDying inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "zombies/basic/death"){}