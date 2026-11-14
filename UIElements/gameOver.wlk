import entity.*
import imageProvider.*

object gameOver inherits Entity(
    position = game.at(2, 0),
    imageProviderSet = noImageProviderSet,
    defaultImageProviderKey = "#None"
){
    override method image() = "sprites/gameOver.png"
}