import imageProvider.*
import planta.*

class Nuez inherits Planta(
    maxHealth = 4000,
    defaultImageProviderKey =  "#Idle",
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(
                key = "#Idle",
                value = wallNutIdleImageProvider
            )      
        ])
){}

object wallNutIdleImageProvider inherits HealthBasedImageProvider( 
    imageProviderSet=[
        wallNutDying,
        wallNutHurt,
        wallNutIdle
    ]
){}

object wallNutDying inherits Sprite(image = "animations/plants/wallNut/dying.gif"){}
object wallNutHurt inherits Sprite(image = "animations/plants/wallNut/hurt.gif"){}
object wallNutIdle inherits Sprite(image = "animations/plants/wallNut/fullHealth.gif"){}