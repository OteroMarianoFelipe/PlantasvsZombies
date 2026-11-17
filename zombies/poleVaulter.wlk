import zombie.*
import entity.*
import imageProvider.*
import actionModule.*
import behavior.*
import util.config.*

class PoleVaulter inherits Zombie(
    maxHealth = 190,
    deathHandler = defaultZombieDeathHandler,
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
    method stopVaulting(){ actionModule.removeBehavior("#Vaulting") }
    method stopRunning(){ actionModule.removeBehavior("#Running") }
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

    override method health(newHealthTotal){
        if(newHealthTotal < maxHealth/3 && not actionModule.hasBehavior("#MeleeAttack")){
            self.stopVaulting()
            self.startMeleeAttack()
        }
        super(newHealthTotal)
    }
}

object vaultingStrategy inherits Strategy{
    override method shouldTick(user) = user.hasObstacle()

    override method use(user, state){
        user.removeVaulting(user)
        user.stopRunning(user)
        user.imageProviderSetUse("#Walking")
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
                value =
                    new HealthBasedImageProvider( 
                        imageProviderSet=[
                            poleVaulterRunningDying,
                            poleVaulterRunningHurt,
                            poleVaulterRunningFH
                        ]
                    )
            ),
            new ImageProviderEntry(
                key = "#Walking",
                value =
                    new HealthBasedImageProvider( 
                        imageProviderSet=[
                            poleVaulterWalkingDying,
                            poleVaulterWalkingHurt,
                            poleVaulterWalkingFH
                        ]
                    )
            ),
            new ImageProviderEntry(
                key = "#Jumping",
                value =
                    new HealthBasedImageProvider( 
                        imageProviderSet=[
                            poleVaulterJumpingHurt,
                            poleVaulterJumpingFH
                        ]
                    )
            ),
            new ImageProviderEntry(
                key = "#MeleeAttack",
                value =
                    new HealthBasedImageProvider(
                        imageProviderSet = [
                            poleVaulterEatingDying,
                            poleVaulterEatingHurt,
                            poleVaulterEatingFH
                        ]
                    )
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