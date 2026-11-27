import imageProvider.*
import entity.*
import zombies.zombie.*
import zombies.zombieBasico.*
import entityTickingManager.*
import actionModule.*
import behavior.*

class ConeHead inherits Zombie(
    maxHealth = 640,
    deathHandler = defaultZombieDeathHandler,
    imageProviderSet = new ConeHeadImageProvider().initialize(),
    defaultImageProviderKey = "#Walking",
    actionModule = 
        new ActionModule(
            behaviors = #{
                new Behavior(
                    key = "#Movement",
                    providerKey = "#Walking",
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
        ),
    thresholdHandler = new ConeHeadHealthThresholds()
){}

class ConeHeadHealthThresholds inherits HealthThreshold(
    thresholds = [
        new Threshold(
            change = { user => 
                const imgProvSet = user.imageProviderSet()
                imgProvSet.add("#Walking", coneHeadWalkingHurt)
                imgProvSet.add("#MeleeAttack", coneHeadEatingHurt)
            },
            condition = new AmountCondition( amount = 520 )
        ),
        new Threshold(
            change = { user => 
                const imgProvSet = user.imageProviderSet()
                imgProvSet.add("#Walking", coneHeadWalkingDying)
                imgProvSet.add("#MeleeAttack", coneHeadEatingDying)
            },
            condition = new AmountCondition( amount = 400 )
        ),
        new Threshold(
            change = { user => 
                user.changeImageProviderSet(new BasicZombieImageProvider())
                user.changeThresholds(new BasicZombieHealthThresholds())
            },
            condition = new AmountCondition( amount = 270 )
        )
    ]
){}

class ConeHeadImageProvider inherits ImageProviderSet{
    method initialize() = 
        self.initialize([
            new ImageProviderEntry(
                key = "#Walking",
                value = coneHeadWalkingFH
            ),
            new ImageProviderEntry(
                key = "#MeleeAttack",
                value = coneHeadEatingFH
            ),
            new ImageProviderEntry(
                key = "#Death",
                value = zombieDying
            )
        ])
}

object coneHeadWalkingDying inherits Sprite(image = "animations/zombies/coneHead/walking/dying.gif"){}
object coneHeadWalkingHurt inherits Sprite(image = "animations/zombies/coneHead/walking/hurt.gif"){}
object coneHeadWalkingFH inherits Sprite(image = "animations/zombies/coneHead/walking/fullHealth.gif"){}

object coneHeadEatingDying inherits Sprite(image = "animations/zombies/coneHead/eating/dying.gif"){}
object coneHeadEatingHurt inherits Sprite(image = "animations/zombies/coneHead/eating/hurt.gif"){}
object coneHeadEatingFH inherits Sprite(image = "animations/zombies/coneHead/eating/fullHealth.gif"){}