import planta.*
import entity.*
import proyectiles.pea.*
import imageProvider.*

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
            shootingAnticipationAnimation = peaShooterActionAnimation
        ) and ActionModule{}
    }.apply(self)
) and Planta(
    startingHealth = 300,
    defaultImageProvider = peaShooterIdleAnimation
){}

object peaShooterIdleAnimation inherits Animation( durationInSeconds = 1, framesInAnimation = 8, animationDirectory = "plants/peashooter/idle"){}
object peaShooterActionAnimation inherits Animation( durationInSeconds = 0.5, framesInAnimation = 4, animationDirectory = "plants/peashooter/active"){}