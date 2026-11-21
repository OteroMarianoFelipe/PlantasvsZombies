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
  
  const infinite = false

  const startingSuns = 200

  var paused = false

  method pause(){
    game.removeTickEvent("tickEntities")
    game.removeTickEvent("AnimateEntities")
  }

  method unpause(){
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
    paused = not paused
  }

  const plantCards = [sunFlowerCard, peashooterCard, wallNutCard, snowPeaCard]

  const property upperBound = game.at(11, 5)
  const property lowerBound = game.at(2, 1)

  method secondsToTicks(seconds) = (seconds * ticksPerSecond).truncate(0)
  method secondsToAnimationTicks(seconds) = (seconds * animationTicksPerSecond).truncate(0)
  method ticksToSeconds(ticks) = (ticks / ticksPerSecond)
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
    sunSpawner.setPeriodicalInstances(10) 
    scriptedSpawner.startScript()
    self.startUIElements()
  }

  method shouldResetScript() = not game.hasVisual(gameOver)

  method controlsConfiguration(){
    game.onClickDo({position =>  player.clickHandler(position) })
    plantCards.size().times({ i =>
      keyboard.num(i).onPressDo({ => player.clickHandler(game.at(2 + i, 0)) })
    })
    keyboard.y().onPressDo({ => scriptedSpawner.spawnEntity(new ZombieBasico())})
    keyboard.u().onPressDo({ => scriptedSpawner.spawnEntity(new ConeHead())})
    keyboard.i().onPressDo({ => scriptedSpawner.spawnEntity(new PoleVaulter())})
    keyboard.o().onPressDo({ => scriptedSpawner.spawnEntity(new FlagZombie())})
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

  method spawningScripFinished(){
    if(not infinite){
      game.onTick(1000, "SearchForZombies",{ =>
        if(zombieTracker.zombieCount() <= 0){
          self.gameFinished()
        }
      })
    }else{
      scriptedSpawner.startScript()
    }
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
    self.clear()
    self.setUpNewGame()
  }
}