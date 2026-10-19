import entity.Entity

class EntidadViva inherits Entity{
    var property vida = self.vidaInicial()
    method vidaInicial()

    override method canBeKilled() = true

    method recibirDanio(cantidad) {
        vida = 0.max(vida - cantidad)
        if(not self.vive()){
            self.stop()
        }
    }
    method vive() = vida > 0
}