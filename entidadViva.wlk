import entity.Entity

class EntidadViva inherits Entity{
    var property health = self.startingHealth()
    method startingHealth()

    override method canBeKilled() = true

    method lives() = health > 0
    method takeDamage(damage) {
        health = 0.max(health - damage)
        if(not self.lives()){
            self.handleOwnRemoval()
        }
    }
}