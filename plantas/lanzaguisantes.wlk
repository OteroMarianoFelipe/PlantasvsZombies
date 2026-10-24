import planta.*
import assets.peaShooter.*
import behavior.*
import proyectiles.pea.*

class LanzaGuisantes inherits Planta(
    startingHealth = 300,
    damage = 20,
    animation = peaShooterIdle,
    actionModule = new ShootingBehavior(
        anticipationAnimation = peaShooterAction, 
        secondsPerUse = 1.5,
        createNewProyectileInstance = { user => 
            new Pea(
                team = user.team(),
                damage = user.damage(),
                frozen = false
            )
        } 
    ),
    behaviorAnticipationAnimation = peaShooterAction
){}