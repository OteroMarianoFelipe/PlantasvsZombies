import animation.*
import proyectiles.projectile.*
import assets.peaShooter.peaShotImpact
import assets.peaShooter.peaShot
import assets.snowPea.frozenPeaImpact
import assets.snowPea.frozenPea

class Pea inherits Projectile(
    animation = peaShot
){
    var property damage
    var property frozen

    var property objective = null
    var property action = { => objective.takeDamage(damage)}
    var property impactAnimation = peaShotImpact
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
            self.changeAndUseDefaultAnimation(frozenPea)
            impactAnimation = frozenPeaImpact
        }
    }
    override method tick(){
        super()
        self.handleCollitions()
    }
    override method handleDeath(){
        self.movementBehavior({=>})
        self.collitionHandler({entity =>})
        animationHandler.changeAnimation(impactAnimation, {=> self.cleanUp()})
    }

    override method defaultMovementBehavior(){ self.position(self.position().right(1)) }
}