import entity.*
import entityManager.entityManager
import imageProvider.*
import proyectiles.projectile.*
import proyectiles.pea.*
import util.config.config
import util.debugger.*

class Planta inherits Alive and Entity(
    team = "PLANTAS",
    defaultImageProvider = imageProviderSet.idle(),
    deathHandler = { user => user.cleanUp() }
){
    var property imageProviderSet

    override method blocksPlantPlacement() = true
    override method blocksEnemyEntitiesMovement() = true
}

class PlantImageProviderSet{
    var property idle
    var property actionAnticipation = idle
}