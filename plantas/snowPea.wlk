import planta.*
import assets.snowPea.*
import proyectiles.projectile.*
import behavior.*
import proyectiles.pea.*

class SnowPea inherits Planta(
    startingHealth = 300,
    damage = 20,
    imageProviderSet = new SnowPeaImageProviderSet(),
    behaviors = [
        new ShootingBehavior(
            anticipationAnimation = new SnowPeaAction(), 
            secondsPerUse = 1.5,
            createNewProyectileInstance = { user => 
                new Pea(
                    team = user.team(),
                    damage = user.damage(),
                    frozen = true
                )
            } 
        )
    ]
){}

class SnowPeaImageProviderSet inherits PlantImageProviderSet(
    idle = new SnowPeaIdle(),
    actionAnticipation = new SnowPeaAction()
){}
