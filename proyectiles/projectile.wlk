import assets.sunFlower.SmallSun
import assets.sunFlower.BigSun
import entityManager.entityManager
import entity.*
import UIElements.sunCounter.sunCounter
import util.config.config

class Projectile inherits Ticks and Collides and Entity() {
    var property behaviors
    
    method inBounds() = self.position().x() <= game.width()-1

    method collisionHandler(entity)

    method handleRemoval()

    override method tick(){
        behaviors.forEach({ behavior =>
            behavior.use(self)
        })
    }
}
