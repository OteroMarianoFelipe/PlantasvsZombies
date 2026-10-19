import planta.*
import util.debugger.*
import assets.peaShooter.*
import proyectiles.projectile.*

class Lanzaguisantes inherits Planta {
  override method price() = 50
  override method vidaInicial() = 300
  override method defaultAnimation() = peaShooterIdle

  override method moduleUseAnimation() = peaShooterAction

  override method defaultActionModule() = new ModuloDisparoDeGuisantes(
    owner=self,
    coolDownInSeconds = 1.5,
    damage = 20
  )

  override method tick(){    
    self.moduloDeAccion().use()
  }
}

class ModuloDisparoDeGuisantes inherits ModuloDeDisparo{
  override method newProjectile() = new Guisante(
    ownTeam = owner.team(),
    damage = self.damage()
  )
}