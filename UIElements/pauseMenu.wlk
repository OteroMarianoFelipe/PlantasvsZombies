object pauseMenu{  
    const property position = game.at(0, 0)
    method cleanUp(){ 
        if(game.hasVisual(self)){ 
            game.removeVisual(self)
        } 
        vignette.cleanUp()
    }
    method show(){ 
        vignette.show()
        game.addVisual(self) 
    }
    method image() = "sprites/pauseMenu.png"
}

object vignette{  
    const property position = game.at(0, 0)
    method cleanUp(){ if(game.hasVisual(self)){ game.removeVisual(self) } }
    method show(){ game.addVisual(self) }
    method image() = "sprites/vignette.png"
}