import util.config.*

object zombieTracker{
    const zombies = #{}
    method zombieCount() = zombies.size()

    const zombiesPerLine = {
        const a = new Dictionary()
        a.initialize()
        config.height().times({ i => a.put(i, 0) })
        return a
    }.apply()
    
    method cleanUp(){ zombies.clear() }

    method areThereZombiesInLine(y) = zombiesPerLine.get(y) > 0

    method addZombie(zombie){
        zombies.add(zombie)
        self.modifyZombiesInLine(zombie.position().y(), +1)
    }
    method removeZombie(zombie){
        zombies.remove(zombie)
        self.modifyZombiesInLine(zombie.position().y(), -1)
    }
    method modifyZombiesInLine(yPos, modifyingAmount){
        const previousValue = zombiesPerLine.get(yPos)
        zombiesPerLine.put(yPos, previousValue + modifyingAmount)
    }
}