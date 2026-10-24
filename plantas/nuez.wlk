import planta.*
import assets.wallNut.*
import behavior.*

class Nuez inherits Planta(
  startingHealth = 4000,
  damage = 0,
  animation = new WallNutIdle(),
  actionModule = noBehavior
){
  var property verificarThresholds = { => self.primerThreshold() }
  method isHurt() = health <= 2/3 * self.startingHealth()
  method isDying() =  health <= 1/3 * self.startingHealth()

  method primerThreshold() { 
    if(not self.isHurt()) {return}
    self.changeAndUseDefaultImageProvider(new WallNutHurtIdle()) 
    self.verificarThresholds({=>self.segundoThreshold()})
    self.verificarThresholds().apply()
    return
  }
  method segundoThreshold() { 
    if(not self.isDying()){return}
    self.changeAndUseDefaultImageProvider(new WallNutDyingIdle())
    self.verificarThresholds({=>})
    return
  }

  override method takeDamage(cantidad){
    super(cantidad)
    verificarThresholds.apply()
  }
}