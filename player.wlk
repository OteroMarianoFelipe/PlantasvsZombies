import juego.*
import entityManager.*
import config.*

object player {
  var property soles = 100
  var property position = game.at(2, 2)
  const costoPlantas = new Dictionary()

  method image() = "cursor.png"

  method inicializarDiccionarioDeCostes() {
    costoPlantas.put("GIRASOL", 25)
    costoPlantas.put("LANZAGUISANTES", 50)
    costoPlantas.put("NUEZ", 50)
  }
  method costePlanta(planta){
    return costoPlantas.get(planta)
  }

  method sumarSoles(cantidad) {
    soles += cantidad
  }

  method gastarSoles(cantidad) {
    soles -= cantidad
  }

  method puedePagar(coste) {
    return soles >= coste
  } 

  method comprar(planta) {
    const coste = self.costePlanta(planta)
    if (self.puedePagar(coste)) {
      self.gastarSoles(coste)
      entityManager.spawn(planta, position)
    }
  }

  method moveVertical(direction){
    var newY = position.y() + direction
    const upperBound = config.upperBound().y()
    const lowerBound = config.lowerBound().y()
    newY = newY.min(upperBound).max(lowerBound)
    position = game.at( position.x(), newY )
  }
  method moveHorizontal(direction){
    var newX = position.x() + direction
    const upperBound = config.upperBound().x()
    const lowerBound = config.lowerBound().x()
    newX = newX.min(upperBound).max(lowerBound)
    position = game.at( newX, position.y() )
  }
}