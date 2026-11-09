import proyectiles.projectile.*
import util.config.*
import UIElements.sunCounter.*
import imageProvider.*

class Sun inherits Projectile(
    defaultImageProvider =  self.getProperAnimation()
){
    const property value

    const property secondsForDesapearing = 10
    var property ticksUntilDesapearing = config.secondsToTicks(secondsForDesapearing)
    method isBig() = self.value() >= 25

    method getProperAnimation(){
        if(self.isBig()){
            return bigSunAnimation
        }else{
            return smallSunAnimation
        }
    }

    override method tick(){
        if(ticksUntilDesapearing == 0){
            self.cleanUp()
        }else{
            ticksUntilDesapearing-=1
        }
    }

    override method collisionHandler(entity){}
    override method beClicked(){
        sunCounter.addSuns(self.value())
        self.handleRemoval()
    }
    override method handleRemoval(){ self.cleanUp() }
}
object bigSunAnimation inherits Animation(durationInSeconds = 0.4, framesInAnimation = 2, animationDirectory = "projectiles/sun/big" ){}
object smallSunAnimation inherits Animation(durationInSeconds = 0.4, framesInAnimation = 2, animationDirectory = "projectiles/sun/small" ){}