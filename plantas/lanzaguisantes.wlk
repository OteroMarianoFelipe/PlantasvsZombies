import planta.*
import entity.*
import proyectiles.pea.*
import imageProvider.*
import actionModule.*
import behavior.*

class LanzaGuisantes inherits Active(
    actionModule =
        new ActionModule(
            behaviors = #{
                new AnticipatedBehavior(
                    name = "#PrimaryShooting",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 3/2 ),
                    anticipationAnimation = peaShooterActionAnimation,
                    state = 
                        {user => object{
                            var property proyectileGenerator = 
                                { user => 
                                    new Pea(
                                        team = user.team(),
                                        damage = 20,
                                        frozen = false
                                    )
                                }
                        }}.apply(self),
                    strategy = conditionalShootingStrategy
                )
            }
        )
) and Planta(
    maxHealth = 300,
    defaultImageProvider = peaShooterIdleAnimation
){}

object peaShooterIdleAnimation inherits Animation( durationInSeconds = 1, framesInAnimation = 8, animationDirectory = "plants/peashooter/idle"){}
object peaShooterActionAnimation inherits Animation( durationInSeconds = 0.5, framesInAnimation = 4, animationDirectory = "plants/peashooter/active"){}