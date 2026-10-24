import zombieBase.*
import assets.zombie.*

class Zombie inherits ZombieBase(
  startingHealth = 190,
  meleeDamage = 100,
  rangedDamage = 0,
  secondsPerMove = 4.7,
  secondsPerAttack = 1,
  animation = zombieWalkingFH
){

  override method walkingAnimations() = [zombieWalkingFH, zombieWalkingHurt, zombieWalkingDying]
  override method eatingAnimations() = [zombieEatingFH, zombieEatingHurt, zombieEatingDying]

  override method deathAnimation() = zombieDeath
}