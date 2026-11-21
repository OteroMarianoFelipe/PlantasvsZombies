import team.*
import util.config.*

object entityTickingManager{
  const entities = []

  method startTicking(){
    game.onTick(1000/config.ticksPerSecond(), "tickEntities", {  
      entities.forEach({entity => 
        entity.tick()
      })  
    })
    
    game.onTick(1000/config.animationTicksPerSecond(), "AnimateEntities", {
      entities.forEach({ entity =>
        entity.animate()
      })
    })
  }

  method add(entity){ entities.add(entity) }
  method remove(entity){ entities.remove(entity) }

  method clear(){
    entities.forEach({ e =>
      self.remove(e)
    })
  }
}