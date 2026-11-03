import assets.zombie.*
import entity.*
import plantas.planta.*
import entityManager.*
import player.*
import util.config.*
import UIElements.gameOver.*
import behavior.*
import util.debugger.*

class Zombie inherits Alive and ActiveEntity and Entity( team = "ZOMBIES"){
    var property imageProviderSet

    var property frozen = 0
    var property freezeTick = false
    var property deathHandler = defaultZombieDeathHandler

    method invertFreezeTick(){ freezeTick = not freezeTick }
    method freeze(){ self.frozen(config.secondsToTicks(10)) }
  
    method crossedTheYard() = position.x() < config.lowerBound().x()

    override method updatePosition(newPosition){
        super(newPosition)
        if(self.crossedTheYard()){
            gameOver.trigger()
            self.cleanUp()
        }
    }

    override method tick(){
        // if(frozen>0){
        //   frozen-=1
        //   self.invertFreezeTick()
        //   if(freezeTick){ return }
        // }
    }

    override method handleDeath(){ deathHandler.apply(self) }
}

object defaultZombieDeathHandler{
    method apply(user){
        user.animationCallback({ => user.cleanUp()}) 
        user.imageProvider(user.imageProviderSet().deathAnimation())
        entityManager.removeEntityCollitions(user)
    }
}

class ZombieImageProviderSet{
    var property walkingImageProvider
    var property eatingImageProvider
    var property deathAnimation
}