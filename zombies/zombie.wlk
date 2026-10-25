import zombieBase.*
import assets.zombie.*
import stateMachine.*
import imageProvider.*
import behavior.*

class Zombie inherits ZombieBase(
    statBlock = new PlaneZombieStats(),
    defaultImageProvider = imageProviderSet.walkingImageProvider(),
    imageProviderSet = new PlaneZombieImageProvidersSet(),
    deathHandler = new StateMachine( currentState = new DefaultZombieDeath() ),
    behaviors = [
        new CollitionBehavior(),
        new StateMachine( 
            currentState = new DefaultZombieMovementBehaviorState() 
        )
    ]
){}

class PlaneZombieStats inherits ZombieStatBlock(
    startingHealth = 190,
    meleeDamage = 100,
    rangedDamage = 0,
    secondsPerCell = 4.7,
    secondsPerAttack = 1
){}

class PlaneZombieImageProvidersSet inherits ZombieImageProviderSet(
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
    deathAnimation = new ZombieDeath()
){} 