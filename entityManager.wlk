import zombies.zombieBase.*
import zombies.zombie.*
import zombies.coneHead.*
import proyectiles.sun.*
import util.azar.*
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

    game.onTick(5000, "spawnZombies",{
      const zombies = []
      const lastColumn = config.upperBound().x()
      azar.numeroEntre(1, 1).times({ i=>
        const zombie = [new Zombie(), new Zombie()].get(azar.numeroEntre(0,1))
        const randomLine = azar.numeroEntre(config.lowerBound().y(), config.upperBound().y())
        game.schedule(i*500, {=> self.addEntity(zombie, game.at(lastColumn, randomLine))})
      })
    })

    game.onTick(10000, "spawnSun",{
      const randomColumn = azar.numeroEntre(config.lowerBound().x(), config.upperBound().x()-1)
      const randomLine = azar.numeroEntre(config.lowerBound().y(), config.upperBound().y())
      const sun = new Sun(ownTeam="PLANTAS", value = 25)
      self.addEntity(sun, game.at(randomColumn, randomLine))
    })
  }

  method cantidadDeEntidades() = entities.size()

  method addEntity(entity, position){
    entity.start(position)
    entities.add(entity)
    entitiesMap.add(entity)
  }

  method allEntitiesThat(condicion) = entities.filter(condicion)
  method allEntitiesAt(pos) = entitiesMap.allEntitiesAt(pos)
  method allIntersectingEntities(entity) = entitiesMap.allEntitiesAt(entity.position()).filter({e=> e!=entity})

  method removeEntityCollitions(entity){
    entitiesMap.remove(entity)
  }

  method removeEntity(entity){
    entities.remove(entity)
    self.removeEntityCollitions(entity)
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
  method add(entity){
    self.allEntitiesAt(entity.position()).add(entity)
  }
  method remove(entity){
    self.allEntitiesAt(entity.position()).remove(entity)
  }

  method updatePosition(entity, previousPos){
    if(entity.position() == previousPos) {return}
    self.allEntitiesAt(previousPos).remove(entity)
    self.add(entity)
    return
  }

}