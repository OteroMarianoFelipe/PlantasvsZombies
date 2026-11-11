import juego.*
import entityTickingManager.*
import util.config.config

object player {
  var property cardSelected = null

  method deselectCard(){ 
    self.cardSelected().deselected()
    self.cardSelected(null) 
  }
  method selectCard(card){ 
    self.cardSelected(card) 
    card.selected()
  }

  method cellIsUnblocked(entities) = not entities.any({e => e.blocksPlantPlacement()})
  method isInBounds(pos) {
    const lb = config.lowerBound()
    const ub = config.upperBound()
    const checksX = pos.x().between(lb.x(), ub.x())
    const checksY = pos.y().between(lb.y(), ub.y())
    return (checksX and checksY)
  }

  method clickHandler(pos){
    const entitiesHere = pos.allElements()
    if( self.cardSelected()!= null){
      if(self.isInBounds(pos) and self.cellIsUnblocked(entitiesHere)){
        self.cardSelected().use(pos)
      }
      self.deselectCard()   
    }
    entitiesHere.forEach({ e => e.beClicked() })
  }
}