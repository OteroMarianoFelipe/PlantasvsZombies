import planta.*
import entity.*
import assets.sunFlower.*
import util.config.*
import entityManager.*
import proyectiles.sun.*
import util.debugger.*

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
    maxHealth = 300,
    imageProviderSet = new SunFlowerImageProviderSet()
){}

class SunFlowerImageProviderSet inherits PlantImageProviderSet(
    idle = new SunFlowerIdle(),
    actionAnticipation = new SunFlowerActive()
){}