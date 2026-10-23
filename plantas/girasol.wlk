import planta.*
import assets.sunFlower.*
import util.config.*
import entityManager.*
import proyectiles.sun.*

class Girasol inherits Planta(
  startingHealth = 300,
  damage = 0,
  animation = sunFlowerIdle
){
  const property generatedSunValue = 25

  override method moduleUseAnimation() = sunFlowerActive

  override method defaultActionModule() = new ModuloDeGeneracionDeSoles(owner = self, coolDownInSeconds = 24.25)

  override method tick(){    
    self.moduloDeAccion().use()
  }
}

class ModuloDeGeneracionDeSoles inherits PlantActionModule{
    override method action(){
      entityManager.addEntity(
        new Sun(
          team = owner.team(),
          value = owner.generatedSunValue()
        ),
        owner.position()
      )
    }
}
