import entity.*
import entityTickingManager.entityTickingManager
import imageProvider.*
import proyectiles.projectile.*
import proyectiles.pea.*
import util.config.config
import util.debugger.*
import team.*

class Planta inherits Alive( 
    deathHandler = { user => user.cleanUp() } 
) and Ticks and Entity(
    team = plantsTeam,
    collides = true
){
    override method blocksPlantPlacement() = true
    override method blocksEnemyEntitiesMovement() = true
}