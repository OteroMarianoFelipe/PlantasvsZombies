import planta.*
import entity.*
import util.config.*
import entityTickingManager.*
import proyectiles.sun.*
import imageProvider.*

class Girasol inherits Active(
    actionModule = { caller =>
        object inherits UnconditionalShooter(
            shotsPerSecond = 1/24.25,
            proyectileGenerator = { user =>  
                    new Sun( 
                        team = user.team(),
                        value = 25
                    ) 
                },
            shootingAnticipationAnimation = sunFlowerActiveAnimation
        ) and ActionModule{}
    }.apply(self)
) and Planta(
    startingHealth = 300,
    defaultImageProvider = sunFlowerIdleAnimation
){}

object sunFlowerIdleAnimation inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "plants/sunFlower/idle"){}
object sunFlowerActiveAnimation inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "plants/sunFlower/active"){}