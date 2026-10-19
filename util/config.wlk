import wollok.game.*
import entityManager.*
import player.*
import plantas.girasol.*
import plantas.lanzaguisantes.*
import plantas.nuez.*
import util.debugger.*
import UIElements.plantCard.*
import UIElements.sunCounter.*
object config {
  const property height = 7
  const property width = 12
  const property animationTicksPerSecond = 30
  const property ticksPerSecond = 5
  const cellSize = 64
  const backGroundImage = "sprites/background.png"

  method upperBound() = game.at(11, 5)
  method lowerBound() = game.at(2, 1)

  method configuracionGeneral(){
    self.configurarVisuales()  
    self.configurarControles()
    entityManager.startTicking()
    entitiesMap.initializeEntitiesMap()
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
    debugger.info("Starting UI elements")
    entityManager.addEntity(sunFlowerCard, game.at(2,0))
    entityManager.addEntity(peashooterCard, game.at(3,0))
    entityManager.addEntity(wallNutCard, game.at(4,0))
    sunCounter.start()
  }
}