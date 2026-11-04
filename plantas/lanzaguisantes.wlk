import planta.*
import entity.*
import assets.peaShooter.*
import proyectiles.pea.*

class LanzaGuisantes inherits ActiveEntity(
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
) and Planta(
    startingHealth = 300,
    imageProviderSet = new PeaShooterImageProviderSet()
){}

class PeaShooterImageProviderSet inherits PlantImageProviderSet(
    idle = new PeaShooterIdle(),
    actionAnticipation = new PeaShooterAction()
){}