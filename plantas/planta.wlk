import entidadViva.*
import entityManager.*

class Planta inherits EntidadViva {
    var property position

    override method start(){
        game.addVisual(self)
    }

    override method stop(){
        game.removeVisual(self)
        entityManager.deleteEntity(self)
    }
}