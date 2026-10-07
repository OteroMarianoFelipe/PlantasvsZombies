// ==========================================
//                  PLANTAS
// ==========================================

class Lanzaguisantes {
  var property vida = 100
  const property danioDisparo = 20

  method costo() = 50

  method recibirDanio(cantidad) {
    vida = 0.max(vida - cantidad)
  }

  method estaViva() = vida > 0

  method atacar(enemigo) {
    enemigo.recibirDanio(danioDisparo)
  }
}

class Nuez {
  var property vida = 400

  method costo() = 50

  method recibirDanio(cantidad) {
    vida = 0.max(vida - cantidad)
  }

  method estaViva() = vida > 0
}

class Girasol {
  var property vida = 80
  const property solesGenerados = 25

  method costo() = 25

  method recibirDanio(cantidad) {
    vida = 0.max(vida - cantidad)
  }

  method estaViva() = vida > 0

  method producirSoles(jardin) {
    jardin.sumarSoles(solesGenerados)
  }
}

// ==========================================
//                 ZOMBIE
// ==========================================

class Zombie {
  var property vida = 80
  var property posicionX = 9
  const property danioMordida = 15

  method estaVivo() = vida > 0

  method recibirDanio(cantidad) {
    vida = 0.max(vida - cantidad)
  }

  // polimorfismo: cualquier planta entiende recibirDanio()
  method atacar(planta) {
    planta.recibirDanio(danioMordida)
  }

  method avanzar() {
    posicionX = 0.max(posicionX - 1)
  }
}

// ==========================================
//            ESTADO DEL JARDIN
// ==========================================

object jardin {
  var property soles = 100

  method sumarSoles(cantidad) {
    soles += cantidad
  }

  method gastarSoles(cantidad) {
    soles -= cantidad
  }

  method puedeComprar(planta) = soles >= planta.costo()

  method comprar(planta) {
    if (self.puedeComprar(planta)) {
      self.gastarSoles(planta.costo())
    }
  }
}