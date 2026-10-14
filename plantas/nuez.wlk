import planta.*

class Nuez inherits Planta{
  var property sprite = "nuez1.png"
  override method vidaInicial() = 400

  override method tick(){
    if( vida <= 1/3 * self.vidaInicial()){
      sprite = "nuez3.png"
      return 
    } 
    if( vida <= 2/3 * self.vidaInicial()){
      sprite = "nuez2.png"
    }
    return
  }

  override method image() = sprite
}