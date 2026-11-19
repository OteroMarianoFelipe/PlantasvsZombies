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
                    key = "#PrimaryShooting",
                    providerKey = "#Shooting",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 3/2 ),
                    state = 
                        {user => object{
                            var property proyectileGenerator = 
                                { user => 
                                    new Pea(
                                        team = user.team(),
                                        damage = 20
                                    )
                                }
                        }}.apply(self),
                    strategy = unconditionalShootingStrategy
                )
            }
        )
) and Planta(
    maxHealth = 300,
    defaultImageProviderKey = "#Idle",
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(
                key = "#Idle",
                value = peashooterIdle
            ),
            new ImageProviderEntry(
                key = "#Shooting",
                value = peashooterAction
            )
        ])
){}

object peashooterIdle inherits Sprite( image = "animations/plants/peashooter/idle.gif" ){}
object peashooterAction inherits Animation(
    durationInSeconds = 0.5,
    framesInAnimation = 4,
    animationDirectory = "plants/peashooter/active"

){}