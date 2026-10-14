import entityManager.*


class Proyectil {
    var property position
    var property danio

    method shoot(planta){
        danio = planta.danio()
        position = planta.position()
        game.addVisual(self)
    }

    method image()

    method inBounds() {
        return self.position().x() <= game.width()
    }

    method avanzar(){
        position=position.right(1)
        if(not self.inBounds()){
            self.stop()
        }
    }

    method start(){
        game.addVisual(self)
    }
    
    method tick()

    method stop(){
        game.removeVisual(self)
        entityManager.deleteEntity(self)
    }
}

class Guisante inherits Proyectil{
  method image() = "guisanteDisparo-tablero.png"
}