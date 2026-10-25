import imageProvider.*
import zombieBase.*
import assets.zombie.*
import zombies.zombie.*
import entityManager.*
import stateMachine.*
import behavior.*

class ConeHead inherits ZombieBase(
    statBlock = new ConeHeadZombieStats(),
    defaultImageProvider = imageProviderSet.walkingImageProvider(),
    imageProviderSet = new ConeHeadImageProvidersSet(),
    behaviorStateMachine = new StateMachine( currentState = new DefaultZombieMovementBehaviorState() ),
    deathHandler = new StateMachine( currentState = new ConeHeadDeath() ),
    collitionBehavior = new CollitionBehavior()
){}

class ConeHeadZombieStats inherits ZombieStatBlock(
    startingHealth = 370,
    meleeDamage = 100,
    rangedDamage = 0,
    secondsPerCell = 4.7,
    secondsPerAttack = 1
){}


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

class ConeHeadDeath inherits State(
    paths = [
        new Path(
            proposedState = new DefaultZombieDeath(),
            condition = { user => return true}
        )
    ]
){
    override method use(user){
        user.startingHealth(190)
        user.health(190)
        user.statBlock( new PlaneZombieStats() )
        user.imageProviderSet( new PlaneZombieImageProvidersSet() )
        if(user.hasAttackTarget()){
            user.defaultImageProvider( user.imageProviderSet().eatingImageProvider() )
        }else{
            user.defaultImageProvider( user.imageProviderSet().walkingImageProvider() )
        }
        user.useDefaultImageProvider()
        user.updateDeathHandler()
    }
}