import zombieBase.*
import assets.zombie.*

class Zombie inherits ZombieBase{
  override method startingHealth() = 190
  override method danioMordida() = 100
  override method secondsPerCell() = 4.7
  override method secondsPerAttack() = 1

  override method walkingAnimations() = [zombieWalkingFH, zombieWalkingHurt, zombieWalkingDying]
  override method eatingAnimations() = [zombieEatingFH, zombieEatingHurt, zombieEatingDying]

  override method deathAnimation() = zombieDeath

  override method defaultAnimation() = zombieWalkingFH
}