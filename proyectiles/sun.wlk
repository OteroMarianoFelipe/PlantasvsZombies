import proyectiles.projectile.*
import util.config.*
import assets.sunFlower.*
import UIElements.sunCounter.*

class Sun inherits Projectile(
    animation = self.getProperAnimation()
){
    const property value

    const property secondsForDesapearing = 10
    var property ticksUntilDesapearing = config.secondsToTicks(secondsForDesapearing)
    method isBig() = self.value() >= 25

    method getProperAnimation(){
        if(self.isBig()){
            return bigSun
        }else{
            return smallSun
        }
    }

    override method defaultMovementBehavior(){}
    override method tick(){
        if(ticksUntilDesapearing == 0){
            self.cleanUp()
        }else{
            ticksUntilDesapearing-=1
        }
    }

    override method defaultSpeed() {return 0}
    override method defaultCollitionHandler(entity){}
    override method beClicked(){
        sunCounter.addSuns(self.value())
        self.handleDeath()
    }
    override method handleDeath(){ self.cleanUp() }
}