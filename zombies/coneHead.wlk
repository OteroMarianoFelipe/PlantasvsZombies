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
    defaultImageProvider =  walkingImageProvider,
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
    behaviorStateMachine = new BehavioralStateMachine( currentState = new DefaultZombieMovementBehaviorState() ),
    deathAnimation = noImageProvider
){
    override method handleDeath(){
        entityManager.addEntity(new Zombie(), self.position())
        self.cleanUp()
    }
}