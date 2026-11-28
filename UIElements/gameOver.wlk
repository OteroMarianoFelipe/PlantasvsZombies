object gameOver{  
    const property position = game.at(2, 0)
    var triggered = false    

    method show(){ 
        triggered = true
        const sound = game.sound("sounds/losemusic.ogg")
        sound.play()
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