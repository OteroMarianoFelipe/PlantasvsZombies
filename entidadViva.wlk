import entity.Entity

class EntidadViva inherits Entity(canBeKilled=true){
    var property startingHealth

    var property health = startingHealth

    method handleDeath()
    method lives() = health > 0
    method takeDamage(damage) {
        health = 0.max(health - damage)
        if(not self.lives()){
            self.handleDeath()
        }
    }
}