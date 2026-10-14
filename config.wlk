import wollok.game.*
import juego.*
import entityManager.*
import player.*

object config {
  const gridBoundsLeft  = 2
  const gridBoundsRight = 11
  const gridBoundsUp    = 4
  const gridBoundsDown  = 0
  const height = 6
  const width = 12
  const cellSize = 80
  const backGroundImage = "background.png"

  method upperBound() = game.at(11, 4)
  method lowerBound() = game.at(2, 0)

  method configuracionGeneral(){
    self.configurarVisuales()  
    self.configurarControles()
    self.inicializarDiccionarios()
  }

  method configurarVisuales(){
    game.title("Line Defense - Plants vs Zombies")
    game.height(height)
    game.width(width)
    game.cellSize(cellSize)
    game.boardGround(backGroundImage)
    game.addVisual(player)
  }

  method configurarControles(){
    //Planting keys

    keyboard.num1().onPressDo({player.comprar("GIRASOL")       })
    keyboard.num2().onPressDo({player.comprar("LANZAGUISANTES")})
    keyboard.num3().onPressDo({player.comprar("NUEZ")          })

    //Movement keys

    keyboard.up().onPressDo(  {player.moveVertical(1)})
    keyboard.w().onPressDo(   {player.moveVertical(1)})
    keyboard.down().onPressDo({player.moveVertical(-1)})
    keyboard.s().onPressDo(   {player.moveVertical(-1)})
    keyboard.left().onPressDo({player.moveHorizontal(-1)})
    keyboard.a().onPressDo(   {player.moveHorizontal(-1)})
    keyboard.right().onPressDo({player.moveHorizontal(1)})
    keyboard.d().onPressDo(    {player.moveHorizontal(1)})
  }

  method inicializarDiccionarios(){
    player.inicializarDiccionarioDeCostes()
    entityManager.inicializarElDiccionarioDeTipos()
  }
}