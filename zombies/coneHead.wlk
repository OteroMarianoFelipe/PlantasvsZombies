import imageProvider.*
import entity.*
import zombies.zombie.*
import zombies.zombieBasico.*
import entityTickingManager.*
import actionModule.*
import behavior.*

class ConeHead inherits Zombie(
    maxHealth = 370,
    deathHandler = coneHeadDeathHandler,
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(
                key = "#Moving",
                value =
                    new HealthBasedImageProvider(
                        imageProviderSet = [
                            coneHeadWalkingDying,
                            coneHeadWalkingHurt,
                            coneHeadWalkingFH
                        ]
                    )
            ),
            new ImageProviderEntry(
                key = "#MeleeAttack",
                value =
                    new HealthBasedImageProvider(
                        imageProviderSet = [
                            coneHeadEatingDying,
                            coneHeadEatingHurt,
                            coneHeadEatingFH
                        ]
                    )
            ),
            new ImageProviderEntry(
                key = "#Death",
                value = noImageProvider
            )
        ]),
    defaultImageProviderKey = "#Moving",
    actionModule = 
        new ActionModule(
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
        )
){}

object coneHeadDeathHandler{
    method changeUsersHealth(user){
        user.maxHealth(190)
        user.health(190)
    }
    method changeUsersImageProviderSet(user){
        user.imageProviderSet( 
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
            ])   
        )
    }

    method apply(user){
        self.changeUsersHealth(user)
        self.changeUsersImageProviderSet(user)
        user.deathHandler(defaultZombieDeathHandler)
    }
}

object coneHeadWalkingDying inherits Sprite(image = "animations/zombies/coneHead/walking/dying.gif"){}
object coneHeadWalkingHurt inherits Sprite(image = "animations/zombies/coneHead/walking/hurt.gif"){}
object coneHeadWalkingFH inherits Sprite(image = "animations/zombies/coneHead/walking/fullHealth.gif"){}

object coneHeadEatingDying inherits Sprite(image = "animations/zombies/coneHead/eating/dying.gif"){}
object coneHeadEatingHurt inherits Sprite(image = "animations/zombies/coneHead/eating/hurt.gif"){}
object coneHeadEatingFH inherits Sprite(image = "animations/zombies/coneHead/eating/fullHealth.gif"){}