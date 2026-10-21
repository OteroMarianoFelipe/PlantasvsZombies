import animation.*
import proyectiles.projectile.*
import assets.peaShooter.peaShotImpact
import assets.peaShooter.peaShot
import assets.snowPea.frozenPeaImpact
import assets.snowPea.frozenPea

class Pea inherits Projectile{
    var property damage
    var property objective = null
    var property frozen
    var property action = { => objective.takeDamage(damage)}
    var property impactAnimation = peaShotImpact
    override method defaultSpeed() = 0
    override method defaultAnimation() = peaShot
    override method defaultCollitionHandler(entity){
        if( self.isEnemy(entity.team()) ) { 
            self.objective(entity)
            action.apply()
            self.handleOwnRemoval()
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
    override method handleOwnRemoval(){
        self.movementBehavior({=>})
        self.collitionHandler({entity =>})
        animationHandler.changeAnimation(impactAnimation, {=> self.cleanUp()})
    }

    override method defaultMovementBehavior(){ self.position(self.position().right(1)) }
}