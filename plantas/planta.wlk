import entidadViva.EntidadViva
import entityManager.entityManager
import imageProvider.*
import proyectiles.projectile.*
import proyectiles.pea.*
import util.config.config
import util.debugger.*

class Planta inherits EntidadViva(
    blocksOwnCell = true,
    team = "PLANTAS",
    defaultImageProvider = imageProviderSet.idle()
){
    var property damage
    var property imageProviderSet
    var property actionModule

    override method tick(){ actionModule.use(self) }
    override method handleDeath(){self.cleanUp()}
    method anticipateBehavior(){ self.changeImageProvider(imageProviderSet.actionAnticipation())  }
}

class PlantImageProviderSet{
    var property idle
    var property actionAnticipation = idle
}