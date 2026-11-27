import team.*
import util.config.*

object entityTickingManager{
  const toFunctionalTick = []
  const toAnimateTick = []

  method startTicking(){
    game.onTick(1000/config.ticksPerSecond(), "tickEntities", {  
      toFunctionalTick.forEach({entity => 
        entity.tick()
      })  
    })
    
    game.onTick(1000/config.animationTicksPerSecond(), "animateEntities", {
      toAnimateTick.forEach({ entity =>
        entity.animate()
      })
    })
  }

  method stop(){
    game.removeTickEvent("tickEntities")
    game.removeTickEvent("animateEntities")
  }

  method addForFunction(entity){
    toFunctionalTick.add(entity)
  }

  method addForAnimation(entity){
    toAnimateTick.add(entity)
  }

  method addForAll(entity){
    self.addForFunction(entity)
    self.addForAnimation(entity)
  }

  method remove(entity){ 
    toFunctionalTick.remove(entity) 
    toAnimateTick.remove(entity)
  }

  method clear(){
    toFunctionalTick.clear()
    toAnimateTick.clear()
  }
}