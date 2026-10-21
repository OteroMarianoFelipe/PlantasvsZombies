import planta.*
import assets.wallNut.*

class Nuez inherits Planta{
  override method startingHealth() = 4000
  override method defaultAnimation() = wallNutIdle
  override method damage() = 0

  override method tick(){}

  var property verificarThresholds = { => self.primerThreshold() }
  method isHurt() = health <= 2/3 * self.startingHealth()
  method isDying() =  health <= 1/3 * self.startingHealth()

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

  override method takeDamage(cantidad){
    super(cantidad)
    verificarThresholds.apply()
  }
}