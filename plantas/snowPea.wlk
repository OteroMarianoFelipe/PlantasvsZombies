import planta.*
import assets.snowPea.*
import proyectiles.projectile.*

class SnowPea inherits Planta(
  startingHealth = 300,
  damage = 20,
  animation = snowPeaIdle
){  
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
