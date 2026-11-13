import planta.*
import entity.*
import proyectiles.sun.*
import imageProvider.*
import actionModule.*
import behavior.*

class Girasol inherits Active(
    actionModule = 
        new ActionModule(
            behaviors = #{
                new AnticipatedBehavior(
                    name = "#PrimaryShooting",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 24.25 ),
                    anticipationAnimation = sunFlowerActiveAnimation,
                    state = 
                        {user => object{
                            var property proyectileGenerator = 
                                { user => 
                                    new Sun(
                                        team = user.team(),
                                        value = 25
                                    )
                                }
                        }}.apply(self),
                    strategy = unconditionalShootingStrategy
                )
            }
        )
) and Planta(
    maxHealth = 300,
    defaultImageProvider = sunFlowerIdleAnimation
){}

object sunFlowerIdleAnimation inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "plants/sunFlower/idle"){}
object sunFlowerActiveAnimation inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "plants/sunFlower/active"){}