import zombies.zombie.*
import zombies.zombieBasico.*
import zombies.coneHead.*
import zombies.poleVaulter.*
import util.config.*
import util.random.*
import imageProvider.*
import entity.*
import proyectiles.sun.*
import team.*
import entityTickingManager.*

class ScriptEntry{
    const property timeInSeconds
    const property entityToSpawn
}

object script{
    const property entries = [
        new ScriptEntry(timeInSeconds = 23 , entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 49 , entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 76 , entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 98 , entityToSpawn = new ConeHead()),
        new ScriptEntry(timeInSeconds = 120, entityToSpawn = new ConeHead()),
        new ScriptEntry(timeInSeconds = 140, entityToSpawn = new PoleVaulter()),
        new ScriptEntry(timeInSeconds = 155, entityToSpawn = new ConeHead()),
        new ScriptEntry(timeInSeconds = 156, entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 174, entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 176, entityToSpawn = new PoleVaulter()),
        new ScriptEntry(timeInSeconds = 187, entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 188, entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 188, entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 213, entityToSpawn = new ZombieBasico()), // Should be flag zombie
        new ScriptEntry(timeInSeconds = 215, entityToSpawn = new PoleVaulter()),
        new ScriptEntry(timeInSeconds = 216, entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 216, entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 216, entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 218, entityToSpawn = new ConeHead()),
        new ScriptEntry(timeInSeconds = 218, entityToSpawn = new ZombieBasico()),
        new ScriptEntry(timeInSeconds = 218, entityToSpawn = new ZombieBasico())
    ]
}

object scriptedSpawner{
    var tickCounter = 0
    var ownScript = []
    const allLines = (config.lowerBound().y() .. config.upperBound().y()).map({ i => i }).asList()
    var linesAvailable = allLines.copy()

    method getRandomLine(){
        if(linesAvailable.size() == 0){ linesAvailable = allLines.copy() }
        const selectedLine = linesAvailable.get(random.numberBetween(0, linesAvailable.size()-1))
        linesAvailable.remove(selectedLine)
        return selectedLine
    }
    
    method instancePosition() = game.at(config.upperBound().x(), self.getRandomLine())

    method finished() = ownScript.size() == 0

    method trySpawn(seconds){
        if(not self.finished()){
            const entry = ownScript.head()
            if(entry.timeInSeconds() <= seconds){
                entry.entityToSpawn().start(self.instancePosition())
                ownScript.remove(entry)
                self.trySpawn(seconds)
            }
        }
    }

    method animate(){}
    method tick(){
        tickCounter += 1
        self.trySpawn(config.ticksToSeconds(tickCounter))
    }

    method startScript(){ 
        ownScript = script.entries().copy()
        tickCounter = 0
        entityTickingManager.add(self) 
    }
}

object spawningManager{
    const spawners = [ basicZombieSpawner, coneHeadZombieSpawner, poleVaulterZombieSpawner, sunSpawner ]

    method startSunSpawning(){
        sunSpawner.setPeriodicalWaves(10, 1)
    }
    method stopSunSpawning(){
        sunSpawner.stopWaves()
    }

    method startSpawning(){        
        basicZombieSpawner.setPeriodicalWaves(20, 2)
        coneHeadZombieSpawner.setPeriodicalWaves(40, 1)
        poleVaulterZombieSpawner.setPeriodicalWaves(20, 1)
        self.startSunSpawning()
    }
    method stopSpawning(){
        spawners.forEach({ spawner =>
            spawner.stopWaves()
        })
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
object poleVaulterZombieSpawner inherits ZombieSpawner(
    secondsBetweenWaveInstances = 6,
    secondsOfVariationForWaveInstances = 0.75,
    wavesEventName = "Pole Vaulter Waves"
){
    override method newInstance() = new PoleVaulter()
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
            team=plantsTeam
        )
}