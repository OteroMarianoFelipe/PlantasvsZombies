import wollok.game.*
import entityManager.*
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

  method upperBound() = game.at(11, 5)
  method lowerBound() = game.at(2, 1)

  method secondsToTicks(seconds) = (seconds * ticksPerSecond).truncate(0)
  method secondsToAnimationTicks(seconds) = (seconds * animationTicksPerSecond).truncate(0)
  method ticksToAnimationTicks(ticks) = (ticks * animationTicksPerSecond / ticksPerSecond).truncate(0)
  method animationTicksToTicks(ticks) = (ticks * ticksPerSecond / animationTicksPerSecond ).truncate(0)

  method configuracionGeneral(){
    self.configurarVisuales()  
    self.configurarControles()
    entityManager.startTicking()
    entitiesMap.initializeEntitiesMap()
    spawningManager.startSpawning()
  }

  method configurarVisuales(){
    game.title("Line Defense - Plants vs Zombies")
    game.height(height)
    game.width(width)
    game.cellSize(cellSize)
    game.boardGround(backGroundImage)
  }

  method configurarControles(){
    game.onClickDo({position => player.clickHandler(position)})
  }

  method startUIElements(){
    sunFlowerCard.start(game.at(2,0))
    peashooterCard.start(game.at(3,0))
    wallNutCard.start(game.at(4,0))
    snowPeaCard.start(game.at(5,0))
    sunCounter.start()
  }

  method perderPartida(){
    game.clear()
    entityManager.clear()
    game.addVisual(gameOver)
  }
}