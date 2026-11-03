import imageProvider.*
import proyectiles.projectile.*
import assets.peaShooter.*
import assets.snowPea.*
import behavior.*
import entityManager.*

class Pea inherits Projectile(
    defaultImageProvider =  new PeaShot(),
    behaviors = [
        new CollitionBehavior(),
        new MovingBehavior(
            secondsPerUse = 0.1,
            movingDirection = game.at(1, 0)
        ),
        new CollitionBehavior()
    ]
){
    var property damage
    var property frozen

    var property objective = null
    var property action = { => objective.takeDamage(damage)}
    var property impactAnimation = new PeaShotImpact()

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
            self.changeAndUseDefaultImageProvider(new FrozenPea())
            impactAnimation = new FrozenPeaImpact()
        }
    }
    override method handleRemoval(){
        behaviors = []
        animationCallback = { => self.cleanUp()} 
        self.imageProvider(impactAnimation)
        entityManager.removeEntityCollitions(self)
    }
}