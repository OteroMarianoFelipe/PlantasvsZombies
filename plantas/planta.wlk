import entidadViva.EntidadViva
import entityManager.entityManager
import animation.*
import proyectiles.projectile.*
import proyectiles.pea.*
import util.config.config

class Planta inherits EntidadViva( blocksOwnCell = true, team = "PLANTAS") {
    var property damage
    
    var property moduloDeAccion = self.defaultActionModule()

    override method handleDeath(){self.cleanUp()}
    method defaultActionModule() = noActions
    method moduleUseAnimation() = animation
    method anticipateUse(){ animationHandler.changeAnimation(self.moduleUseAnimation()) }
}

class PlantActionModule{
    const property owner

    const property animationDuration = self.owner().moduleUseAnimation().durationInTicks()
    const property animationInFTicks = config.animationTicksToTicks(self.animationDuration())

    const property coolDownInSeconds
    const property ticksPerUse = (self.coolDownInSeconds()*config.ticksPerSecond()).truncate(0)
    var property ticksUntilUse = ticksPerUse
    method reduceCoolDown() { ticksUntilUse-=1 }
    method resetCoolDown() { self.ticksUntilUse(ticksPerUse) }

    method use(){
        if(ticksUntilUse==0){
            self.action()
            self.resetCoolDown()
            return
        }
        if(ticksUntilUse == animationInFTicks){
            owner.anticipateUse()
        }
        self.reduceCoolDown()
        return
    }

    method action(){}
}

class ShootingModule inherits PlantActionModule{
    method newProjectile()    
    override method action(){ entityManager.addEntity(self.newProjectile(), owner.position()) }
}

class PeaShootingModule inherits ShootingModule{
    var property arePeasFrozen
    override method newProjectile() = 
        new Pea(
            team = owner.team(),
            damage = owner.damage(),
            frozen = self.arePeasFrozen()
        )
}

object noActions inherits PlantActionModule( owner = self, coolDownInSeconds = 0){
    method moduleUseticksUntilUse() = 0
    method moduleUseAnimation() = noAnimation
    method useAnticipationInTicks() = 0
    override method use(){}
    override method action(){}
}