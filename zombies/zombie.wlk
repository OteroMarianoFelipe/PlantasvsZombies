import assets.zombies.*
import entity.*
import plantas.planta.*
import entityManager.*
import player.*
import util.config.*
import UIElements.gameOver.*
import util.debugger.*

class Zombie inherits Alive and Collides and ActiveEntity and Ticks and Entity(
    team = "ZOMBIES"
){
    var property imageProviderSet

    var property frozen = 0
    var property freezeTick = false

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