import animation.*
import proyectiles.projectile.*
import assets.peaShooter.*
import assets.snowPea.*

class Pea inherits Projectile(
    defaultImageProvider =  new PeaShot()
){
    var property damage
    var property frozen

    var property objective = null
    var property action = { => objective.takeDamage(damage)}
    var property impactAnimation = new PeaShotImpact()
    override method defaultSpeed() = 0
    override method defaultCollitionHandler(entity){
        if( self.isEnemy(entity.team()) ) { 
            self.objective(entity)
            action.apply()
            self.handleDeath()
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
    override method tick(){
        super()
        self.handleCollitions()
    }
    override method handleDeath(){
        self.movementBehavior( { => } )
        self.collitionHandler( {entity =>} )
        animationCallback = { => self.cleanUp()} 
        self.changeImageProvider(impactAnimation)
    }

    override method defaultMovementBehavior(){ self.position(self.position().right(1)) }
}