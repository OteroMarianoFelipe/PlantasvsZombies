import planta.*
import assets.sunFlower.*
import util.config.*
import entityManager.*
import proyectiles.sun.*
import behavior.*
import util.debugger.*

class Girasol inherits Planta(
    startingHealth = 300,
    damage = 0,
    defaultImageProvider =  new SunFlowerIdle(),
    actionModule = new ShootingBehavior(
        anticipationAnimation = new SunFlowerActive(), 
        secondsPerUse = 24.25,
        createNewProyectileInstance = { user =>  
            new Sun( 
                team = user.team(),
                value = user.generatedSunValue() 
            ) 
        } 
    ),
    behaviorAnticipationAnimation = new SunFlowerActive()
){
    var property generatedSunValue = 25
}
