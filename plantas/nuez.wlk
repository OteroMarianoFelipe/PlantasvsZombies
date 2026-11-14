import imageProvider.*
import planta.*

class Nuez inherits Planta(
    maxHealth = 4000,
    defaultImageProviderKey =  "#Idle",
    imageProviderSet = wallNutImageProviderSet
){}

object wallNutImageProviderSet inherits ImageProviderSet(
    entries = #{
        new KeyProviderPair(
            key = "#Idle",
            provider = wallNutIdleImageProvider
        )
    }
){}

object wallNutIdleImageProvider inherits HealthBasedImageProvider( 
    imageProviderSet=[
        wallNutDying,
        wallNutHurt,
        wallNutIdle
    ]
){}

object wallNutDying inherits Animation(durationInSeconds = 1, framesInAnimation = 4, animationDirectory = "plants/wallNut/dying"){}
object wallNutHurt inherits Animation(durationInSeconds = 1, framesInAnimation = 4, animationDirectory = "plants/wallNut/hurt"){}
object wallNutIdle inherits Animation(durationInSeconds = 1, framesInAnimation = 4, animationDirectory = "plants/wallNut/idle"){}