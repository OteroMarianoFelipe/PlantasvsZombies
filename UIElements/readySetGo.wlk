
class FloatingText{
    const property position = game.origin()
    const timeInScreen
    const property image
    const next = null

    method show(){
        game.addVisual(self)
        game.schedule(timeInScreen, { => 
            self.hide()
            if(next != null){
                next.show()
            }
        })
    }
    method hide(){
        game.removeVisual(self)
    }
}
object ready inherits FloatingText(
    image = "sprites/ready.png",
    timeInScreen = 550,
    next = set
){}

object set inherits FloatingText(
    image = "sprites/set.png",
    timeInScreen = 590,
    next = plant
){}

object plant inherits FloatingText(
    image = "sprites/plant.png",
    timeInScreen = 2500
){}