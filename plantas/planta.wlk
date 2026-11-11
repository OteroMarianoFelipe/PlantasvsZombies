import entity.*
import entityManager.entityManager
import imageProvider.*
import proyectiles.projectile.*
import proyectiles.pea.*
import util.config.config
import util.debugger.*

class Planta inherits Alive( 
    deathHandler = { user => user.cleanUp() } 
) and Collides and Ticks and Entity(
    team = "PLANTAS"
){
    override method blocksPlantPlacement() = true
    override method blocksEnemyEntitiesMovement() = true
}