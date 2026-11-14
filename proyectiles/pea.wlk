import entity.*
import imageProvider.*
import proyectiles.projectile.*
import entityTickingManager.*
import actionModule.*
import behavior.*
import util.debugger.*

class Pea inherits HandlesCollisions(
    collitionHandler = { entity =>
        if( self.isEnemy(entity) ) { 
            state.apply(entity, self)
        }
    } 
) and Active(
    actionModule = 
        new ActionModule(
            behaviors = #{
                new Behavior(
                    key = "#Movement",
                    providerKey = "#Moving",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 1/10 ),
                    state = object{ var property movingDirection = game.at(1, 0) },
                    strategy = movingStrategy
                )
            }
        )
) and Projectile( 
    defaultImageProviderKey = "#Moving",
    imageProviderSet = state.imageProviderSet() 
){
    var property damage
    var property state = noEffect
    var removalHandled = false
    method state(newState){
        state = newState
        self.imageProviderSet(state.imageProviderSet())
        self.updateImageProvider()
    }

    override method handleRemoval(){
        if(removalHandled){ 
            self.cleanUp() 
        }else{
            removalHandled = true
            self.removeCollision()
            self.actionModule().clear()
            self.actionModule().stop()
            animationCallback = { => self.cleanUp()} 
            imageHandler.useTempAnimation(state.imageProviderSet().getProvider("#Impact"), 1)
        }
    }
}

object frozenState{
    const property imageProviderSet = 
        new ImageProviderSet(
            entries = #{
                new KeyProviderPair(
                    key = "#Moving",
                    provider = frozenPeaAnimation
                ),
                new KeyProviderPair(
                    key = "#Impact",
                    provider = frozenPeaImpactAnimation
                )
            }
        )

    method apply(entity, user){
        entity.takeDamage(user.damage())
        user.handleRemoval()
    }
}
object noEffect{
    const property imageProviderSet = 
        new ImageProviderSet(
            entries = #{
                new KeyProviderPair(
                    key = "#Moving",
                    provider = peaShotAnimation
                ),
                new KeyProviderPair(
                    key = "#Impact",
                    provider = peaShotImpactAnimation
                )
            }
        )

    method apply(entity, user){
        entity.takeDamage(user.damage())
        user.handleRemoval()
    }
}

object peaShotAnimation inherits Sprite( image = "sprites/projectiles/pea.png" ){}
object peaShotImpactAnimation inherits Animation( durationInSeconds = 0.1, framesInAnimation = 4, animationDirectory = "projectiles/pea/impact"){}

object frozenPeaAnimation inherits Sprite( image = "sprites/projectiles/frozenPea.png" ){}
object frozenPeaImpactAnimation inherits Animation(durationInSeconds = 0.15, framesInAnimation = 6, animationDirectory = "projectiles/frozenPea/impact"){}