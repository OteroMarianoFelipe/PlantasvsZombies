import planta.*
import assets.wallNut.*
import util.debugger.*

class Nuez inherits Planta{
  override method vidaInicial() = 4000
  override method defaultAnimation() = wallNutIdle

  override method tick(){}

  var property verificarThresholds = { => self.primerThreshold() }
  method isHurt() = vida <= 2/3 * self.vidaInicial()
  method isDying() =  vida <= 1/3 * self.vidaInicial()

  method primerThreshold() { 
    if(not self.isHurt()) {return}
    self.changeAndUseDefaultAnimation(wallNutHurtIdle) 
    self.verificarThresholds({=>self.segundoThreshold()})
    self.verificarThresholds().apply()
    return
  }
  method segundoThreshold() { 
    if(not self.isDying()){return}
    self.changeAndUseDefaultAnimation(wallNutDyingIdle)
    self.verificarThresholds({=>})
    return
  }

  override method recibirDanio(cantidad){
    super(cantidad)
    verificarThresholds.apply()
  }
}