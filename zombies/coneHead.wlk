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
    defaultImageProvider = imageProviderSet.walkingImageProvider(),
    imageProviderSet = new ConeHeadImageProvidersSet(),
    behaviorStateMachine = new BehavioralStateMachine( currentState = new DefaultZombieMovementBehaviorState() )
){
    override method handleDeath(){
        entityManager.addEntity(new Zombie(), self.position())
        self.cleanUp()
    }
}

class ConeHeadImageProvidersSet inherits ZombieImageProviderSet(
    walkingImageProvider = new HealthBasedImageProvider(
        imageProviderSet = [
            new ConeHeadWalkingDying(),
            new ConeHeadWalkingHurt(),
            new ConeHeadWalkingFH()
        ]
    ),
    eatingImageProvider = new HealthBasedImageProvider(
        imageProviderSet = [
            new ConeHeadEatingDying(),
            new ConeHeadEatingHurt(),
            new ConeHeadEatingFH()
        ]
    ),
    deathAnimation = noImageProvider
){} 