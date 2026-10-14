import planta.*

class Girasol inherits Planta{

  override method vidaInicial() = 80

  const property solesGenerados = 25

  method producirSoles(jardin) {
    jardin.sumarSoles(solesGenerados)
  }

  override method image() = "sunflower.gif"
}