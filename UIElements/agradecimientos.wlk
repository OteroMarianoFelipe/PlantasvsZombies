import zombieTracker.zombieTracker
import util.config.config

object agradecimientos{  
    const property position = game.at(0, 0)

    method startChecking(){
        game.onTick(1000, "SearchForZombies",{ =>
            if(zombieTracker.zombieCount() <= 0){
                config.gameFinished()
            }
        })
    }

    method hide(){ 
        if(game.hasVisual(self)){ 
            game.removeVisual(self)
        } 
    }
    method show(){  game.addVisual(self) }
    method image() = "sprites/agradecimientos.png"
}
