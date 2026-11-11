import zombies.zombie.*
import zombies.zombieBasico.*
import zombies.coneHead.*
import proyectiles.sun.*
import util.random.*
import util.config.*

object entityManager{
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

  method cantidadDeEntidades() = entities.size()

  method add(entity){
    entities.add(entity)
  }  

  method remove(entity){
    entities.remove(entity)
  }

  method clear(){
    entities.forEach({ e =>
      self.remove(e)
    })
  }
}