import planta.*
import assets.sunFlower.*
import util.config.*
import entityManager.*
import proyectiles.sun.*

class Girasol inherits Planta{
  override method startingHealth() = 300
  const property generatedSunValue = 25
  override method damage() = 0

  override method moduleUseAnimation() = sunFlowerActive
  override method defaultAnimation() = sunFlowerIdle

  override method defaultActionModule() = new ModuloDeGeneracionDeSoles(owner = self, coolDownInSeconds = 24.25)

  override method tick(){    
    self.moduloDeAccion().use()
  }
}

class ModuloDeGeneracionDeSoles inherits PlantActionModule{
    override method action(){
      entityManager.addEntity(
        new Sun(
          ownTeam = owner.team(),
          value = owner.generatedSunValue()
        ),
        owner.position()
      )
    }
}
