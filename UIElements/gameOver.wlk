import zombieTracker.zombieTracker
import util.config.config

object gameOver{  
    const property position = game.at(2, 0)
    var triggered = false

    method startChecking(){
        game.onTick(1000, "SearchForZombies",{ =>
            if(zombieTracker.zombieCount() <= 0){
                config.gameFinished()
            }
        })
    }

    method show(){ 
        triggered = true
        game.addVisual(self) 
    }
    method hide(){ 
        if(triggered){
            triggered = false
            game.removeVisual(self) 
        }
    }
    method image() = "sprites/gameOver.png"
}