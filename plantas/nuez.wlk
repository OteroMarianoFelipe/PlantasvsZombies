import imageProvider.*
import planta.*
import assets.wallNut.*
import behavior.*

class Nuez inherits Planta(
    startingHealth = 4000,
    damage = 0,
    defaultImageProvider =  new HealthBasedImageProvider( 
        imageProviderSet=[
            new WallNutDyingIdle(),
            new WallNutHurtIdle(),
            new WallNutIdle()
        ]
    ),
    actionModule = noBehavior
){}