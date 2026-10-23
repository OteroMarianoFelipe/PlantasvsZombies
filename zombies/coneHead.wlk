import animation.*
import zombieBase.*
import assets.zombie.*
import zombies.zombie.*
import entityManager.*

class ConeHead inherits ZombieBase(
  startingHealth = 370,
  damage = 100,
  secondsPerCell = 4.7,
  secondsPerAttack = 1,
  animation = coneHeadWalkingFH
){
  override method walkingAnimations() = [coneHeadWalkingFH, coneHeadWalkingHurt, coneHeadWalkingDying]
  override method eatingAnimations() =  [coneHeadEatingFH, coneHeadEatingHurt, coneHeadEatingDying]

  override method deathAnimation() = noAnimation

  override method handleDeath(){
    entityManager.addEntity(new Zombie(), self.position())
    self.cleanUp()
  }
}