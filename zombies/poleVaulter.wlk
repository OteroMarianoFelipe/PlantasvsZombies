import zombie.*
import entity.*
import imageProvider.*
import actionModule.*
import behavior.*
import util.config.*
import util.debugger.*

class PoleVaulter inherits Zombie(
    maxHealth = 190,
    imageProviderSet = new PoleVaulterImageProvider(),
    defaultImageProviderKey = "#Running",
    actionModule = 
        object inherits ActionModule(
            behaviors = #{
                new Behavior(
                    key = "#Running",
                    providerKey = "#Running",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 2.5 ),
                    state = object{ var property movingDirection = game.at(-1, 0) },
                    strategy = movingStrategy
                ),
                new Behavior(
                    key = "#Vaulting",
                    providerKey = "#Jumping",
                    sendsProviderCandidate = false,
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 1+config.ticksToSeconds(1) ),
                    state = null,
                    strategy = vaultingStrategy
                )
            }
        ){},
    thresholdHandler = new PoleVaulterHealthThresholds()
){
    method stopVaulting(){ }
    method startWalking(){ 
        actionModule.addBehavior(
            new Behavior(
                key = "#Movement",
                providerKey = "#Walking",
                coolDownTracker = new CoolDownTracker( secondsPerUse = 4.7 ),
                state = object{ var property movingDirection = game.at(-1, 0) },
                strategy = movingStrategy
            )
        )
    }

    method startMeleeAttack(){
        actionModule.addBehavior(
            new Behavior(
                key = "#MeleeAttack",
                providerKey = "#MeleeAttack",
                coolDownTracker = new CoolDownTracker( secondsPerUse = 1 ),
                state = object{ var property damage = 100},
                strategy = meleeAttackStrategy
            )
        )
    }
}

class PoleVaulterHealthThresholds inherits HealthThreshold(
    thresholds = [
        new Threshold(
            change = { user => 
                const imgProvSet = user.imageProviderSet()
                imgProvSet.add("#Walking", poleVaulterWalkingHurt)
                imgProvSet.add("#Running", poleVaulterRunningHurt)
                imgProvSet.add("#Jumping", poleVaulterJumpingHurt)
                imgProvSet.add("#MeleeAttack", poleVaulterEatingHurt)
            },
            condition = new AmountCondition( amount = 95 )
        ),
        new Threshold(
            change = { user => 
                const imgProvSet = user.imageProviderSet()
                imgProvSet.add("#Walking", poleVaulterWalkingDying)
                imgProvSet.add("#Running", poleVaulterRunningDying)
                imgProvSet.add("#MeleeAttack", poleVaulterEatingDying)
                imgProvSet.remove("#Jumping")
                if(not user.actionModule().hasBehavior("#MeleeAttack")){
                    user.stopVaulting()
                    user.startMeleeAttack()
                }
            },
            condition = new AmountCondition( amount = 20 )
        )
    ]
){}

object vaultingStrategy inherits Strategy{
    override method shouldTick(user) = user.hasObstacle()

    override method use(user, state){
        user.actionModule().clear()
        user.imageProviderSetUse("#Walking")
        user.anticipateBehavior( user.imageProviderSet().get("#Jumping") )
        user.animationCallback({ =>
            user.position(user.position().left(1))
            user.startWalking()
            user.startMeleeAttack()
            user.updateImageProvider()
        })
    }
}

class PoleVaulterImageProvider inherits ImageProviderSet{
    method initialize() = 
        self.initialize([
            new ImageProviderEntry(
                key = "#Running",
                value = poleVaulterRunningFH
            ),
            new ImageProviderEntry(
                key = "#Walking",
                value = poleVaulterWalkingFH
            ),
            new ImageProviderEntry(
                key = "#Jumping",
                value = poleVaulterJumpingFH
            ),
            new ImageProviderEntry(
                key = "#MeleeAttack",
                value = poleVaulterEatingFH
            ),
            new ImageProviderEntry(
                key = "#Death",
                value = poleVaulterDying
            )
        ])
}

object poleVaulterWalkingDying inherits Sprite(image = "animations/zombies/poleVaulter/walking/dying.gif"){}
object poleVaulterWalkingHurt  inherits Sprite(image = "animations/zombies/poleVaulter/walking/hurt.gif"){}
object poleVaulterWalkingFH    inherits Sprite(image = "animations/zombies/poleVaulter/walking/fullHealth.gif"){}

object poleVaulterEatingDying inherits Sprite(image = "animations/zombies/poleVaulter/eating/dying.gif"){}
object poleVaulterEatingHurt  inherits Sprite(image = "animations/zombies/poleVaulter/eating/hurt.gif"){}
object poleVaulterEatingFH    inherits Sprite(image = "animations/zombies/poleVaulter/eating/fullHealth.gif"){}

object poleVaulterRunningDying inherits Sprite(image = "animations/zombies/poleVaulter/running/dying.gif"){}
object poleVaulterRunningHurt  inherits Sprite(image = "animations/zombies/poleVaulter/running/hurt.gif"){}
object poleVaulterRunningFH    inherits Sprite(image = "animations/zombies/poleVaulter/running/fullHealth.gif"){}

object poleVaulterJumpingHurt  inherits Animation(durationInSeconds = 1, framesInAnimation = 6, animationDirectory = "zombies/poleVaulter/jumping/hurt"){}
object poleVaulterJumpingFH inherits Animation(durationInSeconds = 1, framesInAnimation = 6, animationDirectory = "zombies/poleVaulter/jumping/FH"){}

object poleVaulterDying inherits Animation(durationInSeconds = 1, framesInAnimation = 8, animationDirectory = "zombies/poleVaulter/death"){}