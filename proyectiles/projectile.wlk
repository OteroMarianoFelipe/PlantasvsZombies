import entityManager.entityManager
import entity.*
import UIElements.sunCounter.sunCounter
import util.config.config

class Projectile inherits Ticks and Entity() {
    
    method inBounds() = self.position().x() <= game.width()-1

    method collisionHandler(entity)

    method handleRemoval()
}
