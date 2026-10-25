import assets.sunFlower.SmallSun
import assets.sunFlower.BigSun
import entityManager.entityManager
import entity.Entity
import UIElements.sunCounter.sunCounter
import util.config.config

class Projectile inherits Entity(blocksOwnCell = false, canBeKilled = false) {
    var property movementBehavior
    var property collitionBehavior
    
    method inBounds() = self.position().x() <= game.width()-1
    method isEnemy(otherTeam) = otherTeam != team and otherTeam != "NEUTRAL"

    method collitionHandler(entity)
    method handleCollitions(){
        const intersectantes = entityManager.allIntersectingEntities(self)
        intersectantes.forEach({ e => self.collitionHandler(e)})
    }

    method handleRemoval()

    override method tick(){
        collitionBehavior.use(self)
        movementBehavior.use(self)
        if(not self.inBounds()){
            self.cleanUp()
        }
    }
}

