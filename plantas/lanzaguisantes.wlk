import planta.*
import entity.*
import assets.peaShooter.*
import behavior.*
import proyectiles.pea.*

class LanzaGuisantes inherits ActiveEntity and Planta(
    startingHealth = 300,
    imageProviderSet = new PeaShooterImageProviderSet(),
    actionModule = {caller => 
        object inherits ConditionedShooter(
            shotsPerSecond = 2/3,     
            proyectileGenerator = { user => 
                new Pea(
                    team = user.team(),
                    damage = 20,
                    frozen = false
                )
            },
            shootingAnticipationAnimation = caller.imageProviderSet().actionAnticipation()
        ) and ActionModule{}
    }.apply(self)
){}

class PeaShooterImageProviderSet inherits PlantImageProviderSet(
    idle = new PeaShooterIdle(),
    actionAnticipation = new PeaShooterAction()
){}