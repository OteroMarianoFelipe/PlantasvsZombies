import planta.*
import entity.*
import assets.snowPea.*
import proyectiles.projectile.*
import behavior.*
import proyectiles.pea.*

class SnowPea inherits ActiveEntity and Planta(
    startingHealth = 300,
    imageProviderSet = new SnowPeaImageProviderSet(),
    actionModule = { caller =>
        object inherits ConditionedShooter(
            shotsPerSecond = 2/3,     
            proyectileGenerator = { user => 
                new Pea(
                    team = user.team(),
                    damage = 20,
                    frozen = true
                )
            },
            shootingAnticipationAnimation = caller.imageProviderSet().actionAnticipation()
        ) and ActionModule{}
    }.apply(self)
){}

class SnowPeaImageProviderSet inherits PlantImageProviderSet(
    idle = new SnowPeaIdle(),
    actionAnticipation = new SnowPeaAction()
){}
