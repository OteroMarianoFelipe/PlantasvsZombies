import UIElements.plantCard.*
import util.debugger.*
import zombies.zombie.*
import zombies.zombieBasico.*
import zombies.coneHead.*
import zombies.poleVaulter.*
import zombies.flagZombie.*
import proyectiles.sun.*
import util.config.config
import util.random.*
import team.*
import entityTickingManager.entityTickingManager
import UIElements.agradecimientos.agradecimientos

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
    method setUp(spawner){ 
        entityTickingManager.addForAll(spawner) 
    }
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

object exampleLevel inherits Level(
    flags = 1,
    zombieWeights = new WeightedZombieList(
        entries = #{
            new WeightedZombieEntry(
                cost = 1,
                newInstanceBlock = { => new ZombieBasico()},
                weight = 4000
            ),
            new WeightedZombieEntry(
                cost = 2,
                newInstanceBlock = { => new ConeHead()},
                weight = 4000
            ),
            new WeightedZombieEntry(
                cost = 2,
                newInstanceBlock = { => new PoleVaulter()},
                weight = 2000,
                lowestWave = 5
            )
        }
    ),
    dificultyOffset = 1
){}

class Level{
    const waves = []
    const flags
    const zombieWeights
    const dificultyOffset
    method setUp(){
        waves.add( new InitialWave( points = self.pointsForWave(0) ) )
        waves.last().pregenerateWave(zombieWeights)
        (flags*10 - 1).times({ i =>
            const newWave = self.newWave(i)
            newWave.pregenerateWave(zombieWeights)
            waves.last().nextWave(newWave)
            waves.add( newWave )
        })
    }

    method newWave(index){
        const wavePoints = self.pointsForWave(index)
        const waveNumber = index + 1
        if(self.isHugeWave(index)){
            return new HugeWave( points = wavePoints * 2.5, waveNumber = waveNumber )
        }else{
            return new Wave( points = wavePoints, waveNumber = waveNumber )
        }
    }
    method isHugeWave(i) = (i+1) % 10 == 0
    method pointsForWave(i) = (i/3).floor() + dificultyOffset

    method start(){ waves.head().startTicking() }
}

class WeightedZombieList{
    const entries
    method availableEntries(budget, wave) = 
        entries.filter({ e => e.canBeBought(budget) && e.canSpawn(wave) })

    method totalWeight(entriesSubSet) = 
        entriesSubSet.sum({ e => e.weight() })

    method rollDice(max) = random.numberBetween(0, max)
    method getEntryFromRoll(entriesSubSet, roll) {
        var rollTemp = roll
        return entriesSubSet.find({ e => 
            rollTemp = rollTemp - e.weight()
            return rollTemp <= 0
        })
    }
    method getRandomZombie(budget, wave){
        const afordableZombies = self.availableEntries(budget, wave)
        const totalWeights = self.totalWeight(afordableZombies)
        return self.getEntryFromRoll(afordableZombies, self.rollDice(totalWeights))
    }
}

class WeightedZombieEntry{
    const property cost
    const property newInstanceBlock
    const property weight
    const property lowestWave = 1

    method canBeBought(budget) = cost <= budget
    method canSpawn(wave) = lowestWave <= wave
}

class Wave{
    var property points
    var started = false
    const waveNumber
    const property rushingHealthThreshold = random.numberBetween(50, 65)
    var property thresholdCheck = rushingThresholdCheck
    const zombiesInWave = []
    const spawningQueue = []
    const spawningQueueTimings = []
    var property nextWave = null
    const property ticksToStart = config.secondsToTicks(random.numberBetween(25, 31))
    var currentTicks = 0
    method currentTicks() = currentTicks
    var property state = waiting
    method nextWave(next){ if(nextWave == null){ nextWave = next } }

    method pregenerateWave(weightedZombieList){
        const entry = weightedZombieList.getRandomZombie(points, waveNumber)
        const newZombie = entry.newInstanceBlock().apply()
        zombiesInWave.add(newZombie)
        points -= entry.cost()
        if(points > 0){ self.pregenerateWave(weightedZombieList) }
    }

    method startTicking(){ entityTickingManager.addForFunction(self) }
    method stopTicking(){ entityTickingManager.remove(self) }

    method startSpawning(){
        self.setSpawningQueue()
        self.trySpawn()
    }

    method changeToInProgress(){
        started = true
        state = inProgress
    }

    method callNextWave(){
        if(nextWave != null){
            nextWave.startTicking()
        }
    }

    method start(){
        if(not started){
            self.startSpawning()
            self.changeToInProgress()
            self.callNextWave()
        }
    }

    method totalHealth() = zombiesInWave.sum({ z => z.health() })
    method totalMaxHealth() = zombiesInWave.sum({ z => z.maxHealth()})
    method healthPercentage() = (self.totalHealth() / self.totalMaxHealth())*100

    method rushNextWave(){
        if(nextWave != null){
            nextWave.rushWave()
        }
    }

    method tickUp(){ currentTicks += 1 }

    method tick(){ state.tick(self) }

    method setSpawningQueue(){ 
        spawningQueue.addAll(zombiesInWave) 
        spawningQueueTimings.add(currentTicks)
        var lastTime = self.currentTicks()
        (spawningQueue.size()-1).times({ i =>
            lastTime += config.secondsToTicks(random.numberBetween(75, 150)/100)
            spawningQueueTimings.add( lastTime )
        })
    }

    method trySpawn(){
        if( not spawningQueueTimings.isEmpty())
        if( currentTicks >= spawningQueueTimings.head() ){
            spawningQueueTimings.remove(spawningQueueTimings.head())
            self.spawn()
        }
    }

    method spawn(){
        const nextInLine = spawningQueue.head()
        spawningQueue.remove(nextInLine)
        laneDirector.spawn(nextInLine)
    }

    method rushWave(){ 
        currentTicks = currentTicks.max( ticksToStart - config.secondsToTicks(2) )
    }
}

class InitialWave inherits Wave( 
    waveNumber = 1,
    ticksToStart = config.secondsToTicks(18.5)
){}

class HugeWave inherits Wave(
    zombiesInWave = [ new FlagZombie() ],
    state = hugeWaveWaiting
){
    override method rushWave(){}
}

class WaitingState{
    method tick(wave){
        if(wave.currentTicks() < wave.ticksToStart()){
            wave.tickUp()
        }else{
            wave.start()
        }
    }
}

object waiting inherits WaitingState{}

object hugeWaveWaiting inherits WaitingState{
    override method tick(wave){
        super(wave)
        if(wave.currentTicks() == wave.ticksToStart() - config.secondsToTicks(7.5)){
            console.println("Huge wave aproaching should be shown")
        }
    }
}

object inProgress{
    method tick(wave){
        wave.tickUp()
        wave.trySpawn()
        wave.thresholdCheck().check(wave)
    }
}

object rushingThresholdCheck{
    method check(wave){
        if(wave.healthPercentage() <= wave.rushingHealthThreshold()){
            wave.rushNextWave()
            wave.thresholdCheck(waveDiedThreshold)
        }
    }
}

object waveDiedThreshold{
    method check(wave){
        if(wave.healthPercentage() <= 0){
            wave.stopTicking()
            if(wave.nextWave() == null){
                agradecimientos.startChecking()
            }
        }
    }
}

object laneDirector{
    const lanes = []
    method initialize(){
        self.cleanUp()
        lanes.addAll((0 .. config.upperBound().y()-1).map({ i => 
            const pos = game.at(config.upperBound().x(), config.lowerBound().y()+i)
            new Lane(position = pos)
        }))
    }
    method cleanUp(){ lanes.clear() }

    method totalLanes() = lanes.size()
    method totalPicks() = lanes.sum({ lane => lane.totalPicked() })
    method evaluateWeights(){
        const totPicks = self.totalPicks()
        const totLanes = self.totalLanes()
        lanes.forEach({ lane => lane.evaluateWeight(totPicks, totLanes) })
    }
    method totalWeight() = lanes.sum({ lane => lane.weight() })
    method chooseSpawningLane(){
        self.evaluateWeights()
        var roll = random.numberBetween(0, self.totalWeight())
        const pickedLane = lanes.find({ lane =>
            roll = roll - lane.weight()
            return roll <= 0
        })
        return pickedLane
    }
    method spawn(entity){
        const lane = self.chooseSpawningLane()
        lanes.forEach({ l => l.notPicked() })
        lane.picked()
        entity.start(lane.position())
    }

    method getLane(yLevel) = lanes.get(yLevel)
}

class Lane{
    const property position

    var totalPicked = 0
    method totalPicked() = totalPicked

    var lastPicked = 0

    var weight = 0
    method weight() = weight * 100

    method picked(){ 
        totalPicked += 1 
        lastPicked = 0
    }
    method notPicked(){ lastPicked += 1 }

    method longTermBalance(totalPicks, laneAmount) = 0.1.max( 1 - (2*totalPicked - totalPicks)/2 )
    method shortTermBalance() = 2.0.min( 0.25 + 0.25 * lastPicked )
    method evaluateWeight(totalPicks, laneAmount) {
        weight = self.longTermBalance(totalPicks, laneAmount) * self.shortTermBalance()
    }
}