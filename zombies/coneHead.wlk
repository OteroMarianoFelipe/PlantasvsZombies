import animation.*
import zombieBase.*
import assets.zombie.*
import zombies.zombie.*
import entityManager.*

class ConeHead inherits ZombieBase(
  startingHealth = 370,
  meleeDamage = 100,
  rangedDamage = 0,
  secondsPerMove = 4.7,
  secondsPerAttack = 1,
  defaultImageProvider =  new ConeHeadWalkingFH()
){
  override method walkingAnimations() = [new ConeHeadWalkingFH(), new ConeHeadWalkingHurt(), new ConeHeadWalkingDying()]
  override method eatingAnimations() =  [new ConeHeadEatingFH(), new ConeHeadEatingHurt(), new ConeHeadEatingDying()]

  override method deathAnimation() = noImageProvider

  override method handleDeath(){
    entityManager.addEntity(new Zombie(), self.position())
    self.cleanUp()
  }
}