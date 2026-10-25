import planta.*
import assets.peaShooter.*
import behavior.*
import proyectiles.pea.*

class LanzaGuisantes inherits Planta(
    startingHealth = 300,
    damage = 20,
    imageProviderSet = new PeaShooterImageProviderSet(),
    actionModule = new ShootingBehavior(
        anticipationAnimation = new PeaShooterAction(), 
        secondsPerUse = 1.5,
        createNewProyectileInstance = { user => 
            new Pea(
                team = user.team(),
                damage = user.damage(),
                frozen = false
            )
        } 
    )
){}

class PeaShooterImageProviderSet inherits PlantImageProviderSet(
    idle = new PeaShooterIdle(),
    actionAnticipation = new PeaShooterAction()
){}