import UIElements.UIElement.*
import entityManager.*

object gameOver inherits UIElement{
    const property position = game.at(6, 1)
    override method image() = "sprites/gameOver.png"

    method trigger(){
        game.addVisual(self)
        entityManager.clear()
    }
}