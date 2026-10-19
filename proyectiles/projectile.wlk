import assets.sunFlower.smallSun
import assets.sunFlower.bigSun
import assets.peaShooter.peaShotImpact
import assets.peaShooter.peaShot
import entityManager.entityManager
import entity.Entity
import UIElements.sunCounter.sunCounter

class Projectile inherits Entity {
    var property ticksPerCell = self.defaultSpeed()
    var property cellMovementCoolDown = self.ticksPerCell()
    var property ownTeam

    method defaultSpeed()

    method resetMovementCoolDown(){ self.cellMovementCoolDown(self.ticksPerCell()) }
    method reduceMovementCoolDown(){ cellMovementCoolDown-=1 }

    override method team() = ownTeam

    method inBounds() {
        return self.position().x() <= game.width()-1
    }

    method isEnemy(team) = team != ownTeam and team != "NEUTRAL"

    method collitionHandler(entity)

    override method tick(){
        const intersectantes = entityManager.allIntersectingEntities(self)
        intersectantes.forEach({ e => self.collitionHandler(e)})
        if(cellMovementCoolDown == 0){
            self.resetMovementCoolDown()
            self.avanzar()
        }else{
            self.reduceMovementCoolDown()
        }
    }
}

class Guisante inherits Projectile{
    var property damage
    var property objective = null
    override method defaultSpeed() = 0
    override method defaultAnimation() = peaShot
    override method collitionHandler(entity){
        if( self.isEnemy(entity.team()) ) { 
            self.objective(entity)
            self.act()
        }
    }
    method act(){
        objective.recibirDanio(damage)
        self.stop()
    }
    override method avanzar(){
        self.position(self.position().right(1))
        super()
        if(not self.inBounds()){
            self.stop()
        }
    }
}

class Sun inherits Projectile{
    const property value
    method isBig() = self.value() == 50

    override method defaultAnimation(){
        if(self.isBig()){
            return bigSun
        }else{
            return smallSun
        }
    }

    override method defaultSpeed() = 0
    override method collitionHandler(entity){}
    override method beClicked(){
        self.act()
    }
    override method act(){
        sunCounter.addSuns(self.value())
        self.stop()
    }
}