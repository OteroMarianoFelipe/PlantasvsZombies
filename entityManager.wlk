import zombies.zombieBase.*
import zombies.zombie.*
import plantas.planta.*
import plantas.girasol.*
import plantas.lanzaguisantes.*
import plantas.nuez.*
import proyectiles.proyectil.*

object entityManager{
  const entities = #{}

  const typeDictionary = new Dictionary()

  method inicializarElDiccionarioDeTipos(){
    typeDictionary.put("GIRASOL"       , { pos => return new Girasol(position = pos)        })
    typeDictionary.put("LANZAGUISANTES", { pos => return new Lanzaguisantes(position = pos) })
    typeDictionary.put("NUEZ"          , { pos => return new Nuez(position = pos)           })
    typeDictionary.put("ZOMBIEB"       , { pos => return new ZombieBasico(position = pos)   })
  }

  method startTicking(){
    game.onTick(100, "tickEverything", {
      self.allZombies().forEach({zombie => zombie.tick()})
      self.allPlants().forEach({zombie => zombie.tick()})
      self.allProjectiles().forEach({zombie => zombie.tick()})
      return
    })
  }
  method allZombies() = entities.filter({entity => entity.isInstanceOf(Zombie)})
  method allPlants() = entities.filter({entity => entity.isInstanceOf(Planta)})
  method allProjectiles() = entities.filter({entity => entity.isInstanceOf(Proyectil)})

  method deleteEntity(entity){
    entities.remove(entity)
  }

  method spawn(type, position){
    const commandoDeCreación = typeDictionary.get(type)
    const nuevaEntidad = commandoDeCreación.apply(position)
    entities.add(nuevaEntidad)
    nuevaEntidad.start()
  }
}