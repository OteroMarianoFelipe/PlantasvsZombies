import util.debugger.*
import zombies.zombie.*
import zombies.zombieBasico.*
import zombies.coneHead.*
import zombies.poleVaulter.*
import zombies.flagZombie.*
import proyectiles.sun.*
import util.config.*
import util.random.*
import team.*
import entityTickingManager.*

class ScriptEntry{
    const property timeInSeconds
    const property entityToSpawn
}

object script{
    const property entries = [
        new ScriptEntry(timeInSeconds = 23 , entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 49 , entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 76 , entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 98 , entityToSpawn = { => new ConeHead()}),
        new ScriptEntry(timeInSeconds = 120, entityToSpawn = { => new ConeHead()}),
        new ScriptEntry(timeInSeconds = 140, entityToSpawn = { => new PoleVaulter()}),
        new ScriptEntry(timeInSeconds = 155, entityToSpawn = { => new ConeHead()}),
        new ScriptEntry(timeInSeconds = 156, entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 174, entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 176, entityToSpawn = { => new PoleVaulter()}),
        new ScriptEntry(timeInSeconds = 187, entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 188, entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 188, entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 213, entityToSpawn = { => new FlagZombie()}),
        new ScriptEntry(timeInSeconds = 215, entityToSpawn = { => new PoleVaulter()}),
        new ScriptEntry(timeInSeconds = 216, entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 216, entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 216, entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 218, entityToSpawn = { => new ConeHead()}),
        new ScriptEntry(timeInSeconds = 218, entityToSpawn = { => new ZombieBasico()}),
        new ScriptEntry(timeInSeconds = 218, entityToSpawn = { => new ZombieBasico()})
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
                self.spawnEntity(entry.entityToSpawn().apply())
                ownScript.remove(entry)
                self.trySpawn(seconds)
            }
        }else{
            self.stopTicking()
            config.spawningScripFinished()
        }
    }

    method animate(){}
    method tick(){
        tickCounter += 1
        self.trySpawn(config.ticksToSeconds(tickCounter))
    }

    method startTicking(){entityTickingManager.add(self) }
    method stopTicking(){entityTickingManager.remove(self)}

    method startScript(){ 
        ownScript = script.entries().copy()
        tickCounter = 0
        self.startTicking()
    }

    method spawnEntity(entity){ entity.start(self.instancePosition()) }
}

object sunSpawner{
    var tickCounter = 0
    var state = idle
    method state(newState){ 
        state = newState
        state.setUp(self)
    }
    var timeBetweenInstances = 0

    method start(){  
        self.state(spawning)
        tickCounter = 0
    }
    method stop(){ self.state(idle) }
    method tickUpTime(){ tickCounter += 1 }
    method shouldSpawn() = 
        tickCounter == config.secondsToTicks(timeBetweenInstances)

    method instancePosition(){
        const randomColumn = random.numberBetween(config.lowerBound().x(), config.upperBound().x()-1)
        const randomLine = random.numberBetween(config.lowerBound().y(), config.upperBound().y())
        return game.at(randomColumn, randomLine)
    }
    method newInstance() = 
        new Sun(
            value = 25,
            team=plantsTeam
        )

    method animate(){}
    method tick(){ state.tick(self)}

    method spawnNewInstance(){
        self.newInstance().start(self.instancePosition())
        tickCounter = 0
    }

    method setPeriodicalInstances(timeInSeconds){
        timeBetweenInstances = timeInSeconds
        self.start()
    }
}

object spawning{
    method setUp(spawner){ entityTickingManager.add(spawner) }
    method tick(spawner){
        spawner.tickUpTime()
        if(spawner.shouldSpawn()){
            spawner.spawnNewInstance()
        }
    }
}

object idle{ 
    method setUp(spawner){ entityTickingManager.remove(spawner) }
    method tick(spawner){} 
}