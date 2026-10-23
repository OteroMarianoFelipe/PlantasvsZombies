import planta.*
import assets.peaShooter.*

class LanzaGuisantes inherits Planta(
  startingHealth = 300,
  damage = 20,
  animation = peaShooterIdle
){
  override method moduleUseAnimation() = peaShooterAction

  override method defaultActionModule() = new PeaShootingModule(
    owner=self,
    coolDownInSeconds = 1.5,
    arePeasFrozen = false
  )

  override method tick(){    
    self.moduloDeAccion().use()
  }
}