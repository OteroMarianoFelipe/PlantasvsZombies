import imageProvider.*
import planta.*
import assets.wallNut.*
import behavior.*

class Nuez inherits Planta(
    startingHealth = 4000,
    damage = 0,
    imageProviderSet =  new WallNutImageProviderSet(),
    actionModule = noBehavior
){}

class WallNutImageProviderSet inherits PlantImageProviderSet(
    idle = new HealthBasedImageProvider( 
        imageProviderSet=[
            new WallNutDyingIdle(),
            new WallNutHurtIdle(),
            new WallNutIdle()
        ]
    )
){}