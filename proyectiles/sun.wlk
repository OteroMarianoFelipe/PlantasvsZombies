import proyectiles.projectile.*
import util.config.*
import UIElements.sunCounter.*
import imageProvider.*

class Sun inherits Projectile( 
    defaultImageProviderKey = self.getProperAnimationKey(),
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(
                key = "#SmallSun",
                value = sunSmall
            ),
            new ImageProviderEntry(
                key = "#BigSun",
                value = sunBig
            )
        ])
){
    const property value

    const property secondsForDesapearing = 10
    var property ticksUntilDesapearing = config.secondsToTicks(secondsForDesapearing)
    method isBig() = self.value() >= 25

    method getProperAnimationKey() = if(self.isBig()) "#BigSun" else "#SmallSun"

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

object sunSmall inherits Sprite(image = "animations/projectiles/sun/small.gif"){}
object sunBig inherits Sprite(image = "animations/projectiles/sun/big.gif"){}