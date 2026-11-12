import entity.*
import imageProvider.*
import proyectiles.projectile.*
import entityTickingManager.*
import actionModule.*

class Pea inherits Active(
    actionModule =
        object inherits HandlesCollisions and Mobile(
            cellsPerSecond = 10,
            movingDirection = game.at(1, 0)
        ) and ActionModule{}
) and Projectile(
    defaultImageProvider = peaShotAnimation
){
    var property damage
    var property frozen

    var property objective = null
    var property action = { => objective.takeDamage(damage)}
    var property impactAnimation = peaShotImpactAnimation

    override method collisionHandler(entity){
        if( self.isEnemy(entity) ) { 
            self.objective(entity)
            action.apply()
            self.handleRemoval()
        }
    }
    override method start(pos){
        super(pos)
        if(frozen){
            action = { => objective.takeDamage(damage) objective.freeze() }
            self.defaultImageProvider(frozenPeaAnimation)
            self.useDefaultImageProvider()
            impactAnimation = frozenPeaImpactAnimation
        }
    }
    override method handleRemoval(){
        self.actionModule().stop()
        animationCallback = { => self.cleanUp()} 
        self.imageProvider(impactAnimation)
        self.removeCollision()
    }
}

object peaShotAnimation inherits Sprite( image = "sprites/projectiles/pea.png" ){}
object peaShotImpactAnimation inherits Animation( durationInSeconds = 0.1, framesInAnimation = 4, animationDirectory = "projectiles/pea/impact"){}

object frozenPeaAnimation inherits Sprite( image = "sprites/projectiles/frozenPea.png" ){}
object frozenPeaImpactAnimation inherits Animation(durationInSeconds = 0.15, framesInAnimation = 6, animationDirectory = "projectiles/frozenPea/impact"){}