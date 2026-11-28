import UIElements.pressToStart.*
import UIElements.agradecimientos.*
import UIElements.pauseMenu.*
import UIElements.sunCounter.*
import UIElements.gameOver.*
import UIElements.readySetGo.*
import util.config.*

object uimanager{
    method pause(){ pauseMenu.show() }
    method unpause(){ pauseMenu.hide() }

    method showGameOver(){ gameOver.show() }
    method showEndCard(){ agradecimientos.show() }

    method showPendingInput(){
        pressToStart.show()
    }
    method hidePendingInput(){
        pressToStart.hide()
    }

    method showReadySetGo(){ ready.show() }

    method initializeUIElements(){
        config.plantCards().size().times({ i =>
            const card = config.plantCards().get(i-1)
            card.start(game.at(2 + i, 0))
            card.reset()
        })
    }

    method hideHUD(){
        config.plantCards().forEach({ card => card.hide()})
        sunCounter.hide()
    }

    method showHUD(){
        config.plantCards().forEach({ card => card.show()})
        sunCounter.show()
    }

    method cleanUp(){
        self.unpause()
        self.hideHUD()
        gameOver.hide()
        agradecimientos.hide()
    }
}