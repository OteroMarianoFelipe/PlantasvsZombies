import util.debugger.*
import zombie.*
import entity.*
import imageProvider.*
import actionModule.*
import behavior.*
import util.config.*

class PoleVaulter inherits Zombie(
    maxHealth = 190,
    deathHandler = defaultZombieDeathHandler,
    imageProviderSet = poleVaulterImageProvidersSet,
    defaultImageProviderKey = "#Running",
    actionModule = 
        object inherits ActionModule(
            behaviors = #{
                new Behavior(
                    key = "#Movement",
                    providerKey = "#Running",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 2.5 ),
                    state = object{ var property movingDirection = game.at(-1, 0) },
                    strategy = movingStrategy
                ),
                new AnticipatedBehavior(
                    key = "#Vaulting",
                    providerKey = "#Jumping",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 1+config.ticksToSeconds(1) ),
                    state = null,
                    strategy = vaultingStrategy
                )
            }
        ){}    
){
    override method health(newHealthTotal){
        if(newHealthTotal < maxHealth/3 && not actionModule.hasBehavior("#MeleeAttack")){
            actionModule.removeBehavior("#Vaulting")
            actionModule.addBehavior(
                new Behavior(
                    key = "#MeleeAttack",
                    providerKey = "#MeleeAttacking",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 1 ),
                    state = object{ var property damage = 100},
                    strategy = meleeAttackStrategy
                )
            )
        }
        super(newHealthTotal)
    }
}

object vaultingStrategy inherits Strategy{
    override method shouldTick(user) = user.hasObstacle()

    method stopRunning(user){user.actionModule().removeBehavior("#Movement") }

    method startWalking(user){
        user.actionModule().addBehavior(
            new Behavior(
                key = "#Movement",
                providerKey = "#Walking",
                coolDownTracker = new CoolDownTracker( secondsPerUse = 4.7 ),
                state = object{ var property movingDirection = game.at(-1, 0) },
                strategy = movingStrategy
            )
        )
    }

    method removeVaulting(user){
        user.actionModule().removeBehavior("#Vaulting")
    }

    method addMeleeAttacking(user){
        user.actionModule().addBehavior(
            new Behavior(
                key = "#MeleeAttack",
                providerKey = "#MeleeAttacking",
                coolDownTracker = new CoolDownTracker( secondsPerUse = 1 ),
                state = object{ var property damage = 100},
                strategy = meleeAttackStrategy
            )
        )
    }

    override method use(user, state){
        self.removeVaulting(user)
        self.stopRunning(user)
        user.imageProviderSetUse("#Walking")
        user.animationCallback({ =>
            user.position(user.position().left(1))
            self.startWalking(user)
            user.updateImageProvider()
            self.addMeleeAttacking(user)
        })
    }
}

object poleVaulterImageProvidersSet inherits ImageProviderSet(
    entries = #{
        new KeyProviderPair(
            key = "#Running",
            provider =
                new HealthBasedImageProvider( 
                    imageProviderSet=[
                        poleVaulterRunningDying,
                        poleVaulterRunningHurt,
                        poleVaulterRunningFH
                    ]
                )
        ),
        new KeyProviderPair(
            key = "#Walking",
            provider =
                new HealthBasedImageProvider( 
                    imageProviderSet=[
                        poleVaulterWalkingDying,
                        poleVaulterWalkingHurt,
                        poleVaulterWalkingFH
                    ]
                )
        ),
        new KeyProviderPair(
            key = "#Jumping",
            provider =
                new HealthBasedImageProvider( 
                    imageProviderSet=[
                        poleVaulterJumpingHurt,
                        poleVaulterJumpingFH
                    ]
                )
        ),
        new KeyProviderPair(
            key = "#MeleeAttacking",
            provider =
                new HealthBasedImageProvider(
                    imageProviderSet=[
                        poleVaulterEatingDying,
                        poleVaulterEatingHurt,
                        poleVaulterEatingFH
                    ]
                )
        ),
        new KeyProviderPair(
            key = "#Death",
            provider = poleVaulterDying
        )
    }
){} 

object poleVaulterWalkingDying inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/poleVaulter/walking/dying"){}
object poleVaulterWalkingHurt  inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/poleVaulter/walking/hurt"){}
object poleVaulterWalkingFH    inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/poleVaulter/walking/FH"){}

object poleVaulterEatingDying inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/poleVaulter/eating/dying"){}
object poleVaulterEatingHurt  inherits Animation(durationInSeconds = 1, framesInAnimation = 8, animationDirectory = "zombies/poleVaulter/eating/hurt"){}
object poleVaulterEatingFH    inherits Animation(durationInSeconds = 1, framesInAnimation = 7, animationDirectory = "zombies/poleVaulter/eating/FH"){}

object poleVaulterRunningDying inherits Animation(durationInSeconds = 1, framesInAnimation = 8, animationDirectory = "zombies/poleVaulter/running/dying"){}
object poleVaulterRunningHurt  inherits Animation(durationInSeconds = 1, framesInAnimation = 8, animationDirectory = "zombies/poleVaulter/running/hurt"){}
object poleVaulterRunningFH    inherits Animation(durationInSeconds = 1, framesInAnimation = 8, animationDirectory = "zombies/poleVaulter/running/FH"){}

object poleVaulterJumpingHurt  inherits Animation(durationInSeconds = 1, framesInAnimation = 6, animationDirectory = "zombies/poleVaulter/jumping/hurt"){}
object poleVaulterJumpingFH inherits Animation(durationInSeconds = 1, framesInAnimation = 6, animationDirectory = "zombies/poleVaulter/jumping/FH"){}

object poleVaulterDying inherits Animation(durationInSeconds = 1, framesInAnimation = 4, animationDirectory = "zombies/poleVaulter/death"){}