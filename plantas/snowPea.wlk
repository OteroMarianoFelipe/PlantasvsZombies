import planta.*
import entity.*
import proyectiles.projectile.*
import proyectiles.pea.*
import imageProvider.*

class SnowPea inherits Active(
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
            shootingAnticipationAnimation = snowPeaAction
        ) and ActionModule{}
    }.apply(self)
) and Planta(
    startingHealth = 300,
    defaultImageProvider = snowPeaIdle
){}

object snowPeaIdle inherits Animation(durationInSeconds = 1, framesInAnimation = 8, animationDirectory = "plants/snowPea/idle"){}
object snowPeaAction inherits Animation(durationInSeconds = 0.5, framesInAnimation = 4, animationDirectory = "plants/snowPea/active"){}