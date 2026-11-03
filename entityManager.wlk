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
  method allEntitiesThat(condicion) = entities.filter(condicion)

  method removeEntityCollitions(entity){
    entitiesMap.remove(entity)
  }

  method removeEntity(entity){
    self.removeEntityCollitions(entity)
    entities.remove(entity)
  }

  method clear(){
    entities.forEach({ e =>
      self.removeEntity(e)
    })
    game.removeTickEvent("tickEntities")
    game.removeTickEvent("AnimateEntities")
    game.removeTickEvent("spawnZombies")
    game.removeTickEvent("spawnSun")
  }
}

object entitiesMap{
  var property spatialGrid = []

  method emptyEntitiesMap(){   
    return (0 .. config.width()).map({ x =>
      (0 .. config.height()).map({ y => [] }).asList()
    }).asList()
  }

  method initializeEntitiesMap(){
    spatialGrid = self.emptyEntitiesMap()
  }

  method allEntitiesAt(pos) = spatialGrid.get(pos.x()).get(pos.y()) 
  method allIntersectingEntities(entity) = self.allEntitiesAt(entity.position()).filter({e=> e!=entity})
  method allEntitiesAtLine(yLevel){
    const entitiesAtYLevel = []
    spatialGrid.forEach({ x =>
      x.get(yLevel).forEach({ e =>
        entitiesAtYLevel.add(e)
      })
    })
    return entitiesAtYLevel
  }
  method add(entity){
    self.allEntitiesAt(entity.position()).add(entity)
  }
  method remove(entity){
    self.allEntitiesAt(entity.position()).remove(entity)
  }

  method updatePosition(entity){
    if(entity.position() == entity.previousPosition()) {return}
    self.allEntitiesAt(entity.previousPosition()).remove(entity)
    self.add(entity)
    return
  }

}