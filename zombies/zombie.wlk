import entity.*
import plantas.planta.*
import entityManager.*
import player.*
import util.config.*
import imageProvider.*

class Zombie inherits Alive and ActiveEntity and Ticks and Entity(
    team = "ZOMBIES",
    collides = true
){
    var property imageProviderSet
    var property frozen = 0

    method freeze(){
        self.actionModule().slowDown(2)
        frozen = config.secondsToTicks(10)
    }

    override method tick(){
        super()
        if(frozen > 0){
            frozen -= 1
            if(frozen == 0){ self.actionModule().restoreSpeed() }
        }
    }
  
    method crossedTheYard() = position.x() < config.lowerBound().x()

    override method position(newPos){
        super(newPos)
        if(self.crossedTheYard()){
            config.perderPartida()
        }
    }
}

object defaultZombieDeathHandler{
    method apply(user){
        user.animationCallback({ => user.cleanUp()}) 
        user.imageProvider(user.imageProviderSet().deathAnimation())
        user.removeCollision()
    }
}

class ZombieImageProviderSet{
    var property walkingImageProvider
    var property eatingImageProvider
    var property deathAnimation
}