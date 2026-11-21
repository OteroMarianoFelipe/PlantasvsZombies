import entity.*
import imageProvider.*

object gameOver{  
    const property position = game.at(2, 0)
    var triggered = false
    method trigger(){ 
        triggered = true
        game.addVisual(self) 
    }
    method cleanUp(){ 
        if(triggered){
            triggered = false
            game.removeVisual(self) 
        }
    }
    method image() = "sprites/gameOver.png"
}