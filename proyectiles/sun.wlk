import proyectiles.projectile.*
import util.config.*
import UIElements.sunCounter.*
import imageProvider.*

class Sun inherits Projectile( 
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(
                key = "#SmallSun",
                value = 
                    object inherits Animation(
                        durationInSeconds = 0.4,
                        framesInAnimation = 2,
                        animationDirectory = "projectiles/sun/small" 
                    ){}
            ),
            new ImageProviderEntry(
                key = "#BigSun",
                value = 
                    object inherits Animation(
                        durationInSeconds = 0.4,
                        framesInAnimation = 2,
                        animationDirectory = "projectiles/sun/big"
                    ){}
            )
        ]),
    defaultImageProviderKey = self.getProperAnimationKey()
){
    const property value

    const property secondsForDesapearing = 10
    var property ticksUntilDesapearing = config.secondsToTicks(secondsForDesapearing)
    method isBig() = self.value() >= 25

    method getProperAnimationKey() = if(self.isBig()) "#BigSun" else "#SmallSun"
    
    override method updateImageProvider(){
        self.imageProvider( imageProviderSet.get(self.getProperAnimationKey()) )
    }

    override method tick(){
        if(ticksUntilDesapearing == 0){
            self.cleanUp()
        }else{
            ticksUntilDesapearing-=1
        }
    }

    override method beClicked(){
        sunCounter.addSuns(self.value())
        self.handleRemoval()
    }
    override method handleRemoval(){ self.cleanUp() }
}