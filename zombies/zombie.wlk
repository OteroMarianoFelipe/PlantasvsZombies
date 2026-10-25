import zombieBase.*
import assets.zombie.*
import stateMachine.*
import imageProvider.*

class Zombie inherits ZombieBase(
    startingHealth = 190,
    meleeDamage = 100,
    rangedDamage = 0,
    secondsPerCell = 4.7,
    secondsPerAttack = 1,
    defaultImageProvider = walkingImageProvider,
    walkingImageProvider = new HealthBasedImageProvider( 
        imageProviderSet=[
            new ZombieWalkingDying(),
            new ZombieWalkingHurt(),
            new ZombieWalkingFH()
        ]
    ),
    eatingImageProvider = new HealthBasedImageProvider(
        imageProviderSet=[
            new ZombieEatingDying(),
            new ZombieEatingHurt(),
            new ZombieEatingFH()
        ]
    ),
    behaviorStateMachine = new BehavioralStateMachine( currentState = new DefaultZombieMovementBehaviorState() ),
    deathAnimation = new ZombieDeath()
){
}