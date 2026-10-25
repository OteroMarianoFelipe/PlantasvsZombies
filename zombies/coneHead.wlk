import imageProvider.*
import zombieBase.*
import assets.zombie.*
import zombies.zombie.*
import entityManager.*
import stateMachine.*

class ConeHead inherits ZombieBase(
  startingHealth = 370,
  meleeDamage = 100,
  rangedDamage = 0,
  secondsPerCell = 4.7,
  secondsPerAttack = 1,
  defaultImageProvider =  new ConeHeadWalkingFH(),
  behaviorStateMachine = new BehavioralStateMachine( currentState = new DefaultZombieMovementBehaviorState() )
){
  override method walkingAnimations() = [new ConeHeadWalkingFH(), new ConeHeadWalkingHurt(), new ConeHeadWalkingDying()]
  override method eatingAnimations() =  [new ConeHeadEatingFH(), new ConeHeadEatingHurt(), new ConeHeadEatingDying()]

  override method deathAnimation() = noImageProvider

  override method handleDeath(){
    entityManager.addEntity(new Zombie(), self.position())
    self.cleanUp()
  }
}