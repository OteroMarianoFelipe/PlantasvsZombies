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
                    strategy = conditionalShootingStrategy
                )
            }
        )
) and Planta(
    maxHealth = 300,
    defaultImageProviderKey = "#Idle",
    imageProviderSet = peaShooterProviderSet
){}

object peaShooterProviderSet inherits ImageProviderSet(
    entries = #{
        new KeyProviderPair(
            key = "#Idle",
            provider = 
                object inherits Animation(
                    durationInSeconds = 1,
                    framesInAnimation = 8,
                    animationDirectory = "plants/peashooter/idle"
                ){}
        ),
        new KeyProviderPair(
            key = "#Shooting",
            provider = 
                object inherits Animation(
                    durationInSeconds = 0.5,
                    framesInAnimation = 4,
                    animationDirectory = "plants/peashooter/active"
                ){}
        )
    }
){}