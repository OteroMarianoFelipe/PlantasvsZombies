object pauseMenu{  
    const property position = game.at(0, 0)
    method hide(){ 
        if(game.hasVisual(self)){ 
            game.removeVisual(self)
        } 
        vignette.hide()
    }
    method show(){ 
        vignette.show()
        game.sound("sounds/pause.ogg").play()
        game.addVisual(self) 
    }
    method image() = "sprites/pauseMenu.png"
}

object vignette{  
    const property position = game.at(0, 0)
    method hide(){ if(game.hasVisual(self)){ game.removeVisual(self) } }
    method show(){ game.addVisual(self) }
    method image() = "sprites/vignette.png"
}