import planta.*
import assets.sunFlower.*
import util.debugger.*
import util.config.*
import entityManager.*
import proyectiles.projectile.Sun

class Girasol inherits Planta{
  override method price() = 25
  override method vidaInicial() = 300
  const property generatedSunValue = 25

  override method moduleUseAnimation() = sunFlowerActive
  override method defaultAnimation() = sunFlowerIdle

  override method defaultActionModule() = new ModuloDeGeneracionDeSoles(owner = self, coolDownInSeconds = 24.25)

  override method tick(){    
    self.moduloDeAccion().use()
  }
}

class ModuloDeGeneracionDeSoles inherits ModuloDeAccionDePlanta{
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
