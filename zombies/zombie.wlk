import zombieBase.*
import assets.zombie.*

class Zombie inherits ZombieBase{
  override method vidaInicial() = 190
  override method danioMordida() = 100
  override method ticksPerCell() = 23
  override method ticksPerAttack() = 10

  override method defaultAnimation() = zombieWalking
}
