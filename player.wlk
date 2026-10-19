import juego.*
import entityManager.entityManager
import util.config.config
import util.debugger.debugger

object player {
  var property position = game.at(2, 3)
  var property cardSelected = null

  method deselectCard(){ 
    self.cardSelected().deselected()
    self.cardSelected(null) 
  }
  method selectCard(card){ 
    self.cardSelected(card) 
    card.selected()
  }

  method cellIsUnblocked(entities) = not entities.any({e => e.blocksOwnCell()})
  method isInBounds(pos) {
    const lb = config.lowerBound()
    const ub = config.upperBound()
    const checksX = pos.x().between(lb.x(), ub.x())
    const checksY = pos.y().between(lb.y(), ub.y())
    return (checksX and checksY)
  }

  method clickHandler(position){
    const entitiesHere = entityManager.allEntitiesAt(position)
    if( self.cardSelected()!= null){
      if(self.isInBounds(position) and self.cellIsUnblocked(entitiesHere)){
        self.cardSelected().use(position)
      }
      self.deselectCard()   
    }
    entitiesHere.forEach({ e => e.beClicked() })
  }
}