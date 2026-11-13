import entity.*
import imageProvider.*
import proyectiles.projectile.*
import entityTickingManager.*
import actionModule.*
import behavior.*

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
                    name = "#Movement",
                    coolDownTracker = new CoolDownTracker( secondsPerUse = 1/10 ),
                    state = object{ var property movingDirection = game.at(1, 0) },
                    strategy = movingStrategy
                )
            }
        )
) and Projectile(
    defaultImageProvider = state.imageProvider()
){
    var property damage
    var property state = noEffect
    method state(newState){
        state = newState
        self.imageProvider(state.imageProvider())
    }

    override method handleRemoval(){
        self.actionModule().stop()
        animationCallback = { => self.cleanUp()} 
        self.imageProvider(state.impactImageProvider())
        self.removeCollision()
    }
}

object frozenState{
    method imageProvider() = frozenPeaAnimation
    method impactImageProvider() = frozenPeaImpactAnimation

    method apply(entity, user){
        entity.takeDamage(user.damage())
        user.handleRemoval()
    }
}
object noEffect{
    method imageProvider() = peaShotAnimation
    method impactImageProvider() = peaShotImpactAnimation

    method apply(entity, user){
        entity.takeDamage(user.damage())
        user.handleRemoval()
    }
}

object peaShotAnimation inherits Sprite( image = "sprites/projectiles/pea.png" ){}
object peaShotImpactAnimation inherits Animation( durationInSeconds = 0.1, framesInAnimation = 4, animationDirectory = "projectiles/pea/impact"){}

object frozenPeaAnimation inherits Sprite( image = "sprites/projectiles/frozenPea.png" ){}
object frozenPeaImpactAnimation inherits Animation(durationInSeconds = 0.15, framesInAnimation = 6, animationDirectory = "projectiles/frozenPea/impact"){}