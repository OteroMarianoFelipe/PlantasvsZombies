import wollok.game.*
import player.*
import entityTickingManager.*
import UIElements.plantCard.*
import UIElements.sunCounter.*
import spawning.*
import zombieTracker.*
import util.debugger.*
import UIManager.*

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
    backgroundMusic.pause()
    paused = true
    entityTickingManager.stop()
  }

  method unpause(){
    backgroundMusic.resume()
    paused = false
    uimanager.unpause()
    entityTickingManager.startTicking()
  }

  method switchPausedState(){
    if(paused){
      self.unpause()
    }else{
      self.pause()
      uimanager.pause()
    }
  }

  const property plantCards = [sunFlowerCard, peashooterCard, wallNutCard, snowPeaCard]

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
    uimanager.initializeUIElements()
  }

  method setUpBGM(){
    const music = game.sound("sounds/Graze the Roof.mp3")
    backgroundMusic.music(music)
  }

  method pendingInput(){
    uimanager.showPendingInput()
    game.schedule(250,{ => 
      keyboard.any().onPressDo({ =>
        keyboard.any().clean()
        uimanager.hidePendingInput()
        self.prepareForGame()
      })
    })
  }

  method prepareForGame(){
    const sound = game.sound("sounds/readysetplant.ogg")
    sound.play()
    uimanager.showReadySetGo()
    game.schedule(3600, { => self.startGame()})
  }

  method startGame(){
    sunCounter.suns(startingSuns)
    entityTickingManager.startTicking()
    exampleLevel.start()
    backgroundMusic.play()
    uimanager.showHUD()
    sunSpawner.setPeriodicalInstances(10) 
    self.controlsConfiguration()
  }

  method setUpNewGame(){
    laneDirector.initialize()
    exampleLevel.setUp()
    self.setUpBGM()
    self.pendingInput()
  }

  method controlsConfiguration(){
    game.onClickDo({position =>  player.clickHandler(position) })
    plantCards.size().times({ i =>
      keyboard.num(i).onPressDo({ => player.clickHandler(game.at(2 + i, 0)) })
    })
    keyboard.p().onPressDo({ => self.switchPausedState()})
    keyboard.r().onPressDo({ => self.resetGame()})
  }

  method gameFinished(){
    self.pause()
    uimanager.showEndCard()
    game.removeTickEvent("SearchForZombies")
  }

  method clear(){
    uimanager.cleanUp()
    plantCards.forEach({ p => p.reset() })
    entityTickingManager.clear()
    sunSpawner.stop()
    game.clear()
  }

  method lose(){
    backgroundMusic.stop()
    entityTickingManager.clear()
    uimanager.hideHUD()
    uimanager.showGameOver()
  }

  method resetGame(){
    self.unpause()
    self.clear()
    backgroundMusic.stop()
    self.setUpNewGame()
  }
}

object backgroundMusic{
  var volume = 1
  var music = game.sound("")
  var property state = stopped

  method volume(newVolume){
    volume = newVolume
    music.volume(newVolume)
  }
  method music(newMusic){ 
    music = newMusic 
    music.shouldLoop(true)
    music.volume(volume)
  }

  method play(){state.play(music, self)}
  method stop(){state.stop(music, self)}
  method pause(){ state.pause(music, self) }
  method resume(){ state.resume(music, self) }
}

object playing {
  method play(sound, manager){}
  method stop(sound, manager){ 
    sound.stop() 
    manager.state(stopped)
  }
  method pause(sound, manager){ 
    sound.pause() 
    manager.state(paused)
  }
  method resume(sound, manager){}
}
object stopped {
  method play(sound, manager){
    sound.play()
    manager.state(playing)
  }
  method stop(sound, manager){}
  method pause(sound, manager){}
  method resume(sound, manager){
    sound.play()
    manager.state(playing)
  }
}
object paused {
  method play(sound, manager){
    sound.resume()
    manager.state(playing)
  }
  method stop(sound, manager){}
  method pause(sound, manager){}
  method resume(sound, manager){
    sound.resume()
    manager.state(playing)
  }
}