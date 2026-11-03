import entity.*
import entityManager.entityManager
import imageProvider.*
import proyectiles.projectile.*
import proyectiles.pea.*
import util.config.config
import util.debugger.*

class Planta inherits Alive and Entity(
    team = "PLANTAS",
    defaultImageProvider = imageProviderSet.idle()
){
    var property imageProviderSet

    override method blocksPlantPlacement() = true
    override method blocksEnemyEntitiesMovement() = true

    override method tick(){}
    //override method tick(){ 
    //    behaviors.forEach({ behavior => 
    //        behavior.use(self) 
    //    })
    //}
    override method handleDeath(){self.cleanUp()}
}

class PlantImageProviderSet{
    var property idle
    var property actionAnticipation = idle
}