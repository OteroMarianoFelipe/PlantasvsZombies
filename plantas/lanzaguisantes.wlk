import planta.*
import assets.peaShooter.*
import behavior.*
import proyectiles.pea.*

class LanzaGuisantes inherits Planta(
    startingHealth = 300,
    damage = 20,
    defaultImageProvider =  new PeaShooterIdle(),
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
    ),
    behaviorAnticipationAnimation = new PeaShooterAction()
){}