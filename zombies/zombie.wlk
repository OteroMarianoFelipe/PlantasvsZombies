import zombieBase.*
import assets.zombie.*

class Zombie inherits ZombieBase(
  startingHealth = 190,
  meleeDamage = 100,
  rangedDamage = 0,
  secondsPerMove = 4.7,
  secondsPerAttack = 1,
  defaultImageProvider = new ZombieWalkingFH()
){

  override method walkingAnimations() = [new ZombieWalkingFH(), new ZombieWalkingHurt(), new ZombieWalkingDying()]
  override method eatingAnimations() = [new ZombieEatingFH(), new ZombieEatingHurt(), new ZombieEatingDying()]

  override method deathAnimation() = new ZombieDeath()
}