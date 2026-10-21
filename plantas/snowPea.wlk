import planta.*
import assets.snowPea.*
import assets.snowPea.*
import proyectiles.projectile.*

class SnowPea inherits Planta {
  override method startingHealth() = 300
  override method damage() = 20
  
  override method defaultAnimation() = snowPeaIdle
  override method moduleUseAnimation() = snowPeaAction

  override method defaultActionModule() = new PeaShootingModule(
    owner=self,
    coolDownInSeconds = 1.5,
    arePeasFrozen = true
  )

  override method tick(){    
    self.moduloDeAccion().use()
  }
}
