import planta.*
import assets.snowPea.*
import proyectiles.projectile.*
import behavior.*
import proyectiles.pea.*

class SnowPea inherits Planta(
  startingHealth = 300,
  damage = 20,
  animation = snowPeaIdle,
  actionModule = new ShootingBehavior(
        anticipationAnimation = snowPeaAction, 
        secondsPerUse = 1.5,
        createNewProyectileInstance = { user => 
            new Pea(
                team = user.team(),
                damage = user.damage(),
                frozen = true
            )
        } 
    ),
  behaviorAnticipationAnimation = snowPeaAction
){}
