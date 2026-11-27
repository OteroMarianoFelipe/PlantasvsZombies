object agradecimientos{  
    const property position = game.at(0, 0)
    method hide(){ 
        if(game.hasVisual(self)){ 
            game.removeVisual(self)
        } 
    }
    method show(){  game.addVisual(self) }
    method image() = "sprites/agradecimientos.png"
}
