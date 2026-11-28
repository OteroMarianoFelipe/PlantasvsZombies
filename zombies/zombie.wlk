import zombieTracker.*
import entity.*
import plantas.planta.*
import entityTickingManager.*
import player.*
import util.config.*
import imageProvider.*
import team.*

class Zombie inherits Alive(
    deathHandler = defaultZombieDeathHandler
) and Active and Entity(
    team = zombiesTeam,
    collides = true
){
    var frozen = 0

    method freeze(){
        if(frozen == 0){
            const sound = game.sound("sounds/zombies/frozen.ogg")
            sound.play()
        }
        self.actionModule().slowDown(2)
        frozen = config.secondsToTicks(10)
    }

    override method start(pos){
        super(pos)
        zombieTracker.addZombie(self)
    }

    override method cleanUp(){
        game.removeVisual(self)
        zombieTracker.removeZombie(self)
    }

    method meleeAttack(entity, damage){
        entity.takeDamage(damage)
        const sound = [
            game.sound("sounds/zombies/chomp/1.ogg"),
            game.sound("sounds/zombies/chomp/2.ogg"),
            game.sound("sounds/zombies/chomp/3.ogg")
        ].get(0.randomUpTo(2))
        sound.play()
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
            config.lose()
        }
    }
}

object defaultZombieDeathHandler{
    method apply(user){
        user.actionModule().clear()
        user.actionModule().stop()
        user.removeCollision()
        const sound = [
            game.sound("sounds/zombies/falling/1.ogg"),
            game.sound("sounds/zombies/falling/2.ogg")
        ].get(0.randomUpTo(1))
        sound.play()
        user.animationCallback({ => user.cleanUp()})
        user.imageHandler().useTempAnimation(user.imageProviderSet().get("#Death"), 1)
    }
}

class ZombieImageProviderSet{
    var property walkingImageProvider
    var property eatingImageProvider
    var property deathAnimation
}