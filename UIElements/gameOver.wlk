import UIElements.UIElement.*
import entityManager.*

object gameOver inherits UIElement(position = game.at(1,1)){
    override method image() = "sprites/gameOver.png"

    override method tick(){}
    method trigger(){
        game.addVisual(self)
        entityManager.clear()
    }
}