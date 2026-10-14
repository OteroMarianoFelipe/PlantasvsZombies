class EntidadViva {
    var property vida = self.vidaInicial()
    method vidaInicial()

    method recibirDanio(cantidad) {
        vida = 0.max(vida - cantidad)
        if(not self.vive()){
            self.stop()
        }
    }
    method vive() = vida > 0

    method image() = ""

    method start(){
        game.addVisual(self)
    }

    method tick() {}

    method stop(){
        game.removeVisual(self)
    }
}