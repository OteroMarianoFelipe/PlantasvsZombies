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
                    key = "#PrimaryShooting",
                    providerKey = "#Shooting",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 3/2 ),
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
    defaultImageProviderKey = "#Idle",
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(
                key = "#Idle",
                value = 
                    new Animation(
                        durationInSeconds = 1,
                        framesInAnimation = 8,
                        animationDirectory = "plants/snowPea/idle"
                    )
            ),
            new ImageProviderEntry(
                key = "#Shooting",
                value = 
                    new Animation(
                        durationInSeconds = 0.5,
                        framesInAnimation = 4,
                        animationDirectory = "plants/snowPea/active"
                    )
            )
        ])
){}