import planta.*
import entity.*
import assets.snowPea.*
import proyectiles.projectile.*
import proyectiles.pea.*

class SnowPea inherits ActiveEntity(
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
) and Planta(
    maxHealth = 300,
    imageProviderSet = new SnowPeaImageProviderSet()
){}

class SnowPeaImageProviderSet inherits PlantImageProviderSet(
    idle = new SnowPeaIdle(),
    actionAnticipation = new SnowPeaAction()
){}
