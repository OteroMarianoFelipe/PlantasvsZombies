object pressToStart{
    const property position = game.origin()

    method show(){
        if(not game.hasVisual(self)){
            game.addVisual(self)
        }
    }

    method hide(){
        if(game.hasVisual(self)){
            game.removeVisual(self)
        }
    }

    method image() = "sprites/pressToStart.png"
}