import animation.*
import zombieBase.*
import assets.zombie.*
import zombies.zombie.*
import entityManager.*

class ConeHead inherits ZombieBase{
  override method startingHealth() = 370
  override method danioMordida() = 100
  override method secondsPerCell() = 4.7
  override method secondsPerAttack() = 1

  override method walkingAnimations() = [coneHeadWalkingFH, coneHeadWalkingHurt, coneHeadWalkingDying]
  override method eatingAnimations() =  [coneHeadEatingFH, coneHeadEatingHurt, coneHeadEatingDying]

  override method deathAnimation() = noAnimation

  override method defaultAnimation() = coneHeadWalkingFH

  override method handleOwnRemoval(){
    entityManager.addEntity(new Zombie(), self.position())
    self.cleanUp()
  }
}