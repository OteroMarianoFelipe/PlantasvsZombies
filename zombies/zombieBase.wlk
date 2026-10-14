import entidadViva.*
import plantas.planta.*
import entityManager.*

class ZombieBase inherits EntidadViva{
    var property position
    var property objetivoDeAtaque = null
    const property danio = self.danioMordida() 

    method danioMordida()

    method atacar(planta) {
      planta.recibirDanio(danio)
    }

    method avanzar() {
      position.x(0.max(position.x() - 1)) 
    }

    override method start(){
        game.addVisual(self)
        game.onCollideDo(self, { otraEntidad =>
          // Si es planta ataca a la entidad, caso contrario la ignora
          if(otraEntidad.isInstanceOf(Planta) && objetivoDeAtaque == null){
            objetivoDeAtaque = otraEntidad
          }
        })
    }

    override method tick(){
      if(objetivoDeAtaque == null){
        self.avanzar()
      }else{
        self.atacar(objetivoDeAtaque)
        if(objetivoDeAtaque.vive()){
          objetivoDeAtaque = null
        }
      }
    }

    override method stop(){
        game.removeVisual(self)
        entityManager.deleteEntity(self)
    }
}
