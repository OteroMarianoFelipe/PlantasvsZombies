import planta.*
import entity.*
import proyectiles.projectile.*
import proyectiles.pea.*
import imageProvider.*
import actionModule.*
import behavior.*

class SnowPea inherits Active(
    actionModule = 
        new ActionModule(
            behaviors = #{
                new AnticipatedBehavior(
                    name = "#PrimaryShooting",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 3/2 ),
                    anticipationAnimation = snowPeaAction,
                    state = 
                        {user => object{
                            var property proyectileGenerator = 
                                { user => 
                                    new Pea(
                                        team = user.team(),
                                        damage = 20,
                                        state = frozenState
                                    )
                                }
                        }}.apply(self),
                    strategy = conditionalShootingStrategy
                )
            }
        )
) and Planta(
    maxHealth = 300,
    defaultImageProvider = snowPeaIdle
){}

object snowPeaIdle inherits Animation(durationInSeconds = 1, framesInAnimation = 8, animationDirectory = "plants/snowPea/idle"){}
object snowPeaAction inherits Animation(durationInSeconds = 0.5, framesInAnimation = 4, animationDirectory = "plants/snowPea/active"){}