import planta.*
import assets.sunFlower.*
import util.config.*
import entityManager.*
import proyectiles.sun.*
import behavior.*

class Girasol inherits Planta(
    startingHealth = 300,
    damage = 0,
    animation = sunFlowerIdle,
    //actionModule = new ModuloDeGeneracionDeSoles(owner = self, coolDownInSeconds = 24.25),
    actionModule = new ShootingBehavior(
        anticipationAnimation = sunFlowerActive, 
        secondsPerUse = 24.25,
        createNewProyectileInstance = { user =>  
            new Sun( 
                team = user.team(),
                value = user.generatedSunValue() 
            ) 
        } 
    ),
    behaviorAnticipationAnimation = sunFlowerActive
){
    var property generatedSunValue = 25
}
