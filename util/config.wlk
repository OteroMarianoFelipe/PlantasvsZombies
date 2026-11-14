import wollok.game.*
import entityTickingManager.*
import player.*
import UIElements.plantCard.*
import UIElements.sunCounter.*
import spawningManager.*
import UIElements.gameOver.*

object config {
  const property height = 7
  const property width = 12
  const property animationTicksPerSecond = 30
  const property ticksPerSecond = 5
  const cellSize = 64
  const backGroundImage = "sprites/background.png"

  const startingSuns = 200

  const plantCards = [sunFlowerCard, peashooterCard, wallNutCard, snowPeaCard]

  const property upperBound = game.at(11, 5)
  const property lowerBound = game.at(2, 1)

  method secondsToTicks(seconds) = (seconds * ticksPerSecond).truncate(0)
  method secondsToAnimationTicks(seconds) = (seconds * animationTicksPerSecond).truncate(0)
  method ticksToAnimationTicks(ticks) = (ticks * animationTicksPerSecond / ticksPerSecond).truncate(0)
  method animationTicksToTicks(ticks) = (ticks * ticksPerSecond / animationTicksPerSecond ).truncate(0)

  method isInGardenBounds(pos) = pos.x().between(lowerBound.x(), upperBound.x()) && pos.y().between(lowerBound.y(), upperBound.y())
  method isInBounds(pos) = pos.x().between(0, width) && pos.y(0, height)

  method gameConfigurations(){
    game.title("Line Defense - Plants vs Zombies")
    game.height(height)
    game.width(width)
    game.cellSize(cellSize)
    game.boardGround(backGroundImage)
  }

  method setUpNewGame(){
    self.controlsConfiguration()
    entityTickingManager.startTicking()
    spawningManager.startSpawning()
    self.startUIElements()
  }

  method controlsConfiguration(){
    game.onClickDo({position => player.clickHandler(position)})
    plantCards.size().times({ i =>
      keyboard.num(i).onPressDo({ => player.clickHandler(game.at(1 + i, 0)) })
    })
    keyboard.r().onPressDo({ => self.resetGame()})
  }

  method startUIElements(){
    plantCards.size().times({ i =>
      const card = plantCards.get(i-1)
      card.start(game.at(1 + i, 0))
      card.reset()
    })
    sunCounter.suns(startingSuns)
    sunCounter.start()
  }

  method clear(){
    game.clear()
    entityTickingManager.clear()
    spawningManager.stopSpawning()
  }

  method lose(){
    game.addVisual(gameOver)
  }

  method resetGame(){
    self.clear()
    self.setUpNewGame()
  }
}