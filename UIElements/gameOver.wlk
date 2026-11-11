import entity.*

object gameOver inherits Entity(
    team = "NEUTRAL", position = game.at(2, 0)
){
    override method image() = "sprites/gameOver.png"
}