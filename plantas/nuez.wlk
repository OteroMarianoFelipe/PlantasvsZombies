import imageProvider.*
import entity.*
import planta.*

class Nuez inherits Planta(
    maxHealth = 4000,
    defaultImageProviderKey =  "#Idle",
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(
                key = "#Idle",
                value = wallNutIdle
            )      
        ]),
    thresholdHandler = wallNutHealthThresholds
){}

object wallNutHealthThresholds inherits HealthThreshold(
    thresholds = [
        new Threshold(
            change = { user => 
                const imgProvSet = user.imageProviderSet()
                imgProvSet.add("#Idle", wallNutHurt)
            },
            condition = new PercentageCondition( percentage = 0.66 )
        ),
        new Threshold(
            change = { user => 
                const imgProvSet = user.imageProviderSet()
                imgProvSet.add("#Idle", wallNutDying)
            },
            condition = new PercentageCondition( percentage = 0.33 )
        )
    ]
){}

object wallNutDying inherits Sprite(image = "animations/plants/wallNut/dying.gif"){}
object wallNutHurt inherits Sprite(image = "animations/plants/wallNut/hurt.gif"){}
object wallNutIdle inherits Sprite(image = "animations/plants/wallNut/fullHealth.gif"){}