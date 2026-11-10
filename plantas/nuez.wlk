import imageProvider.*
import planta.*

class Nuez inherits Planta(
    startingHealth = 4000,
    defaultImageProvider =  wallNutImageProvider
){}

object wallNutImageProvider inherits HealthBasedImageProvider( 
    imageProviderSet=[
        wallNutDying,
        wallNutHurt,
        wallNutIdle
    ]
){}

object wallNutDying inherits Animation(durationInSeconds = 1, framesInAnimation = 4, animationDirectory = "plants/wallNut/dying"){}
object wallNutHurt inherits Animation(durationInSeconds = 1, framesInAnimation = 4, animationDirectory = "plants/wallNut/hurt"){}
object wallNutIdle inherits Animation(durationInSeconds = 1, framesInAnimation = 4, animationDirectory = "plants/wallNut/idle"){}