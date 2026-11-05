import imageProvider.*
import planta.*
import assets.wallNut.*

class Nuez inherits Planta(
    maxHealth = 4000,
    imageProviderSet =  new WallNutImageProviderSet()
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