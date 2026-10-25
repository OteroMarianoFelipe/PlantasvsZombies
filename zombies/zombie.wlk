import zombieBase.*
import assets.zombie.*
import stateMachine.*

class Zombie inherits ZombieBase(
  startingHealth = 190,
  meleeDamage = 100,
  rangedDamage = 0,
  secondsPerCell = 4.7,
  secondsPerAttack = 1,
  defaultImageProvider = new ZombieWalkingFH(),
  behaviorStateMachine = new BehavioralStateMachine( currentState = new DefaultZombieMovementBehaviorState() )
){

  override method walkingAnimations() = [new ZombieWalkingFH(), new ZombieWalkingHurt(), new ZombieWalkingDying()]
  override method eatingAnimations() = [new ZombieEatingFH(), new ZombieEatingHurt(), new ZombieEatingDying()]

  override method deathAnimation() = new ZombieDeath()
}