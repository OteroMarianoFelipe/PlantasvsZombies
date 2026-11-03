import planta.*
import entity.*
import assets.sunFlower.*
import util.config.*
import entityManager.*
import proyectiles.sun.*
import behavior.*
import util.debugger.*

class Girasol inherits ActiveEntity and Planta(
    startingHealth = 300,
    imageProviderSet = new SunFlowerImageProviderSet(),
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
){}

class SunFlowerImageProviderSet inherits PlantImageProviderSet(
    idle = new SunFlowerIdle(),
    actionAnticipation = new SunFlowerActive()
){}