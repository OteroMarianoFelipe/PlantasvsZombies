import juego.*
import entityTickingManager.*
import util.config.config

object player {
  var property cardSelected = null

  method reset(){
    self.deselectCard()
  }

  method deselectCard(){ 
    self.cardSelected().deselected()
    self.cardSelected(null) 
  }
  method selectCard(card){ self.cardSelected(card) }

  method cellIsUnblocked(entities) = not entities.any({e => e.blocksPlantPlacement()})

  method clickHandler(pos){
    const entitiesHere = pos.allElements()
    if( self.cardSelected()!= null){
      if(config.isInGardenBounds(pos) and self.cellIsUnblocked(entitiesHere)){
        self.cardSelected().use(pos)
      }
      self.deselectCard()   
    }
    entitiesHere.forEach({ e => e.beClicked() })
  }
}