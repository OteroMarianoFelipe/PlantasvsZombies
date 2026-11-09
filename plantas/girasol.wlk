import planta.*
import entity.*
import util.config.*
import entityManager.*
import proyectiles.sun.*
import imageProvider.*

class Girasol inherits ActiveEntity(
    actionModule = { caller =>
        object inherits UnconditionalShooter(
            shotsPerSecond = 1/24.25,
            proyectileGenerator = { user =>  
                    new Sun( 
                        team = user.team(),
                        value = 25
                    ) 
                },
            shootingAnticipationAnimation = caller.imageProviderSet().actionAnticipation()
        ) and ActionModule{}
    }.apply(self)
) and Planta(
    startingHealth = 300,
    imageProviderSet = sunFlowerImageProviderSet
){}

object sunFlowerImageProviderSet inherits PlantImageProviderSet(
    idle = sunFlowerIdleAnimation,
    actionAnticipation = sunFlowerActiveAnimation
){}

object sunFlowerIdleAnimation inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "plants/sunFlower/idle"){}
object sunFlowerActiveAnimation inherits Animation(durationInSeconds = 1, framesInAnimation = 9, animationDirectory = "plants/sunFlower/active"){}