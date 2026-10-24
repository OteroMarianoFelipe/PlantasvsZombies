import entidadViva.EntidadViva
import entityManager.entityManager
import animation.*
import proyectiles.projectile.*
import proyectiles.pea.*
import util.config.config
import util.debugger.*

class Planta inherits EntidadViva( blocksOwnCell = true, team = "PLANTAS") {
    var property damage
    var property actionModule
    var property behaviorAnticipationAnimation = animation

    override method tick(){ actionModule.use(self) }
    override method handleDeath(){self.cleanUp()}
    method anticipateBehavior(){ animationHandler.changeAnimation(behaviorAnticipationAnimation)  }
}