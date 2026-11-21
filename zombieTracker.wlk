object zombieTracker{
    const zombies = #{}
    method zombieCount() = zombies.size()
    
    method cleanUp(){ zombies.clear() }

    method addZombie(zombie){
        zombies.add(zombie)
    }
    method removeZombie(zombie){
        zombies.remove(zombie)
    }
}