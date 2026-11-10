import zombies.zombie.*
import zombies.zombieBasico.*
import zombies.coneHead.*
import util.config.*
import util.random.*
import imageProvider.*
import entity.*
import proyectiles.sun.*

object spawningManager{
    method startSpawning(){
        basicZombieSpawner.setPeriodicalWaves(5, 3)
        coneHeadZombieSpawner.setPeriodicalWaves(40, 2)
        sunSpawner.setPeriodicalWaves(10, 1)
    }
    method stopSpawning(){
        basicZombieSpawner.stopWaves()
        coneHeadZombieSpawner.stopWaves()
        sunSpawner.stopWaves()
    }
}

class Spawner{
    var property secondsBetweenWaveInstances
    var property secondsOfVariationForWaveInstances

    var property wavesEventName

    method newInstance()
    method instancePosition()

    method spawnNewWave(amount){
        amount.times({ i =>
            const instance = self.newInstance()
            const timeInMilliseconds = i * ( secondsBetweenWaveInstances*1000 + random.numberBetween(0,secondsOfVariationForWaveInstances*1000))
            game.schedule( 
                timeInMilliseconds,
                { => instance.start(self.instancePosition())}
            )
        })
    }

    method setPeriodicalWaves(timeBetweenWavesInSeconds, entitiesPerWave){
        game.onTick(timeBetweenWavesInSeconds * 1000, wavesEventName,{ self.spawnNewWave(entitiesPerWave) })
    }

    method stopWaves(){
        game.removeTickEvent(wavesEventName)
    }
}
class ZombieSpawner inherits Spawner{
    method allLines() = (config.lowerBound().y() .. config.upperBound().y()).map({ i => i }).asList()
    var linesAvailable = []

    method getRandomLine(){
        if(linesAvailable.size() == 0){
            linesAvailable = self.allLines()
        }
        const selectedLine = linesAvailable.get(random.numberBetween(0, linesAvailable.size()-1))
        linesAvailable.remove(selectedLine)
        return selectedLine
    }
    
    override method instancePosition() = game.at(config.upperBound().x(), self.getRandomLine())
    override method stopWaves(){
        super()
        linesAvailable = []
    }
}

object basicZombieSpawner inherits ZombieSpawner(
    secondsBetweenWaveInstances = 5,
    secondsOfVariationForWaveInstances = 0.75,
    wavesEventName = "Basic Zombie Waves"
){
    override method newInstance() = new ZombieBasico()
}

object coneHeadZombieSpawner inherits ZombieSpawner(
    secondsBetweenWaveInstances = 6,
    secondsOfVariationForWaveInstances = 0.75,
    wavesEventName = "Basic Zombie Waves"
){
    override method newInstance() = new ConeHead()
}

object sunSpawner inherits Spawner(
    secondsBetweenWaveInstances = 3,
    secondsOfVariationForWaveInstances = 0.1,
    wavesEventName = "SolarFlare"
){
    override method instancePosition(){
        const randomColumn = random.numberBetween(config.lowerBound().x(), config.upperBound().x()-1)
        const randomLine = random.numberBetween(config.lowerBound().y(), config.upperBound().y())
        return game.at(randomColumn, randomLine)
    }
    override method newInstance() = 
        new Sun(
            value = 25,
            team="PLANTAS"
        )
}