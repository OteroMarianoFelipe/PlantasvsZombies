import wollok.game.*
import player.*
import zombies.zombieBasico.*
import zombies.coneHead.*
import zombies.flagZombie.*
import zombies.poleVaulter.*
import entityTickingManager.*
import UIElements.agradecimientos.*
import UIElements.plantCard.*
import UIElements.sunCounter.*
import UIElements.pauseMenu.*
import spawning.*
import zombieTracker.*
import UIElements.gameOver.*
import util.debugger.*

object config {
  const property height = 7
  const property width = 12
  const property animationTicksPerSecond = 10
  const property ticksPerSecond = 5
  const cellSize = 64
  const backGroundImage = "sprites/background.png"

  const startingSuns = 200

  var paused = false

  method pause(){
    paused = true
    entityTickingManager.stop()
  }

  method unpause(){
    paused = false
    pauseMenu.cleanUp()
    entityTickingManager.startTicking()
  }

  method switchPausedState(){
    if(paused){
      self.unpause()
    }else{
      self.pause()
      pauseMenu.show()
    }
  }

  const plantCards = [sunFlowerCard, peashooterCard, wallNutCard, snowPeaCard]

  const property upperBound = game.at(11, 5)
  const property lowerBound = game.at(2, 1)

  method secondsToTicks(seconds) = (seconds * ticksPerSecond).floor()
  method secondsToAnimationTicks(seconds) = (seconds * animationTicksPerSecond).floor()
  method ticksToSeconds(ticks) = (ticks / ticksPerSecond)
  method ticksToAnimationTicks(ticks) = (ticks * animationTicksPerSecond / ticksPerSecond).floor()
  method animationTicksToTicks(ticks) = (ticks * ticksPerSecond / animationTicksPerSecond ).floor()

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
    sunSpawner.setPeriodicalInstances(10) 
    laneDirector.initialize()
    exampleLevel.setUp()
    exampleLevel.start()
    self.startUIElements()
    self.pause()
    pauseMenu.show()
  }

  method controlsConfiguration(){
    game.onClickDo({position =>  player.clickHandler(position) })
    plantCards.size().times({ i =>
      keyboard.num(i).onPressDo({ => player.clickHandler(game.at(2 + i, 0)) })
    })
    keyboard.p().onPressDo({ => self.switchPausedState()})
    keyboard.r().onPressDo({ => self.resetGame()})
  }

  method startUIElements(){
    sunCounter.suns(startingSuns)
    plantCards.size().times({ i =>
      const card = plantCards.get(i-1)
      card.start(game.at(2 + i, 0))
      card.reset()
    })
    sunCounter.start()
  }

  method gameFinished(){
    self.pause()
    agradecimientos.show()
    game.removeTickEvent("SearchForZombies")
  }

  method clear(){
    gameOver.cleanUp()
    entityTickingManager.clear()
    sunSpawner.stop()
    game.clear()
  }

  method lose(){
    self.clear()
    gameOver.trigger()
  }

  method resetGame(){
    self.unpause()
    self.clear()
    self.setUpNewGame()
  }
}