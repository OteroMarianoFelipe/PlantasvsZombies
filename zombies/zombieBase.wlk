import entidadViva.*
import plantas.planta.*
import entityManager.*
import player.*
import util.config.*

class ZombieBase inherits EntidadViva{
  var property healthStage = 1
  var property objetivoDeAtaque = null
  var property ticksHastaAvance = self.ticksPerCell()
  var property ticksHastaAtaque = self.ticksPerAttack()
  const property danio = self.danioMordida() 

  override method team() = "ZOMBIES"

  method danioMordida()
  method ticksPerCell()
  method ticksPerAttack()

  method collisionHandler(otraEntidad){
    // Si es planta ataca a la entidad, caso contrario la ignora
    if(otraEntidad.team()==self.team() or otraEntidad.team()=="NEUTRAL") {return}
    if(not self.tieneObjetivo() and otraEntidad.canBeKilled()){
      self.objetivoDeAtaque(otraEntidad)
      self.coolDownAtaque()
      self.coolDownAvance()
    }
    return
  }

  method tieneObjetivo() = self.objetivoDeAtaque() != null

  override method avanzar() { 
    if(self.ticksHastaAvance()!=0){
      self.reducirCoolDownDeAvanze()
      return
    }
    self.position(position.left(1) )
    super()
    self.coolDownAvance()
    return 
  }
  method coolDownAvance(){ ticksHastaAvance = self.ticksPerCell() }
  method reducirCoolDownDeAvanze(){
    self.ticksHastaAvance(ticksHastaAvance-1)
  }

  method atacar() {
    if(self.ticksHastaAtaque() == 0){
      self.objetivoDeAtaque().recibirDanio(danio)
      self.coolDownAtaque()
    }else{
      self.reducirCoolDownDeAtaque()
    }
    if(not self.objetivoDeAtaque().vive()){ 
      self.objetivoDeAtaque(null)
    }
    return
  }
  method coolDownAtaque() { self.ticksHastaAtaque(self.ticksPerAttack()) }
  method reducirCoolDownDeAtaque(){
    self.ticksHastaAtaque(self.ticksHastaAtaque()-1)
  }

  method crossedTheYard() = position.x() < config.lowerBound().x()

  override method tick(){
    const intersectantes = entityManager.allIntersectingEntities(self)
    intersectantes.forEach({entity => 
      self.collisionHandler(entity)
    })
    if(self.tieneObjetivo()){
      self.atacar()
    }else{
      self.avanzar()
      if(self.crossedTheYard()){
        self.stop()
        //console.println("Falta implementar condición de perdida")
      }
    }
  }
}
