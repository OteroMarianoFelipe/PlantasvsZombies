import assets.sunFlower.smallSun
import assets.sunFlower.bigSun
import entityManager.entityManager
import entity.Entity
import UIElements.sunCounter.sunCounter
import util.config.config

class Projectile inherits Entity {
    var property collitionHandler = { entity => self.defaultCollitionHandler(entity)}
    var property movementBehavior = { => self.defaultMovementBehavior()}
    var property ticksPerCell = self.defaultSpeed()
    var property cellMovementCoolDown = ticksPerCell
    var property ownTeam

    method defaultSpeed()
    method defaultMovementBehavior()
    method defaultCollitionHandler(entity)

    method resetMovementCoolDown(){ self.cellMovementCoolDown(ticksPerCell) }
    method reduceMovementCoolDown(){ cellMovementCoolDown-=1 }

    method inBounds() = self.position().x() <= game.width()-1
    method isEnemy(team) = team != ownTeam and team != "NEUTRAL"

    method handleCollitions(){
        const intersectantes = entityManager.allIntersectingEntities(self)
        intersectantes.forEach({ e => collitionHandler.apply(e)})
    }
    
    method move(){
        if(cellMovementCoolDown == 0){
            self.resetMovementCoolDown()
            movementBehavior.apply()
        }else{
            self.reduceMovementCoolDown()
        }
        self.updateMapPosition()
    }

    override method team() = ownTeam
    override method tick(){
        self.handleCollitions()
        self.move()
        if(not self.inBounds()){
            self.cleanUp()
        }
    }
}

