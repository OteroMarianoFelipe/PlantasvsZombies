import planta.*
import entity.*
import proyectiles.sun.*
import imageProvider.*
import actionModule.*
import behavior.*

class Girasol inherits Active(
    actionModule = 
        new ActionModule(
            behaviors = #{
                new AnticipatedBehavior(
                    key = "#PrimaryShooting",
                    providerKey = "#Active",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 24.25 ),
                    state = 
                        {user => object{
                            var property proyectileGenerator = 
                                { user => 
                                    new Sun(
                                        team = user.team(),
                                        value = 25
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
                value = 
                    object inherits Animation(
                        durationInSeconds = 1,
                        framesInAnimation = 9,
                        animationDirectory = "plants/sunFlower/idle"
                    ){}
            ),
            new ImageProviderEntry(
                key = "#Active",
                value = 
                    object inherits Animation(
                        durationInSeconds = 1,
                        framesInAnimation = 9,
                        animationDirectory = "plants/sunFlower/active"
                    ){}
            )
        ])
){}