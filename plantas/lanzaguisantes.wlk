import planta.*
import assets.peaShooter.*

class LanzaGuisantes inherits Planta {
  override method startingHealth() = 300
  override method defaultAnimation() = peaShooterIdle
  override method damage() = 20

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