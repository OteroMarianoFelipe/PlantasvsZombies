import entidadViva.EntidadViva
import entityManager.entityManager
import animation.*
import util.debugger.debugger
import util.config.config

class Planta inherits EntidadViva {
    var property moduloDeAccion = self.defaultActionModule()
    override method team() = "PLANTAS"
    override method blocksOwnCell()=true
    method defaultActionModule() = sinAcciones
    method moduleUseAnimation() = self.defaultAnimation()
    method anticipateUse(){ self.changeCurrentAnimation(self.moduleUseAnimation()) }
}

class ModuloDeAccionDePlanta{
    const property owner

    const property animationDuration = self.owner().moduleUseAnimation().durationInTicks()
    const property animationInFTicks = self.animationTicksToFunctionalTicks(self.animationDuration())
    method animationTicksToFunctionalTicks(ticks) = config.animationTicksPerSecond()/config.ticksPerSecond()    

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

class ModuloDeDisparo inherits ModuloDeAccionDePlanta{
    var property damage
    method newProjectile()    
    override method action(){ entityManager.addEntity(self.newProjectile(), owner.position()) }
}

object sinAcciones inherits ModuloDeAccionDePlanta( owner = self, coolDownInSeconds = 0){
    method moduleUseticksUntilUse() = 0
    method moduleUseAnimation() = noAnimation
    method useAnticipationInTicks() = 0
    override method use(){}
    override method action(){}
}