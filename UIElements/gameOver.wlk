import entity.*

object gameOver inherits Entity(team = "NEUTRAL", position = game.at(1,1)){
    override method image() = "sprites/gameOver.png"
}