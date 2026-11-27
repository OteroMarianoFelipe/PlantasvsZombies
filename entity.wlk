import zombies.coneHead.*
import zombies.zombie.*
import imageProvider.*
import imageProviderHandler.*
import entityTickingManager.*
import behavior.*
import util.config.*
import util.debugger.*
import team.*

class Entity{
    var property team = neutralTeam
    const property defaultImageProviderKey
    const property imageHandler = new ImageProviderHandler( imageProvider = noImageProvider )
    var usingDefaultImageProvider = false
    
    const property blocksPlantPlacement = false
    const property blocksEnemyMovement = false
    
    var imageProviderSet
    method imageProviderSet() = imageProviderSet
    
    var collides = false
    method collides() = collides

    const collidingEntities = []
    var collisionsUpToDate = false
    method outDatedCollisions(){ collisionsUpToDate = false }
    method collidingEntities(){
        if(not collisionsUpToDate){
            self.evaluateCollisions()    
        }
        return collidingEntities
    }
    method evaluateCollisions(){
        collisionsUpToDate = true
        collidingEntities.clear()
        collidingEntities.addAll(position.allElements().filter({ e => e != self && e.collides()}))
    }

    var property animationCallback = {=>}
    var property position = game.at(0,0)

    method isEnemy(other) = team.isEnemy(other)
    method beClicked(){}

    method start(pos){
        self.useDefaultProvider()
        self.position(pos)
        game.addVisual(self)
    }

    method changeImageProviderSet(newSet){ imageProviderSet = newSet }
    
    method cleanUp(){ game.removeVisual(self) }

    method removeCollision(){ collides = false }
    method restoreCollision(){ collides = true }

    method outOfBounds(){ self.cleanUp() }

    method obstacles() = self.collidingEntities().filter({ e => self.isEnemy(e) && e.blocksEnemyMovement()})
    method hasObstacle() = not self.obstacles().isEmpty()

    method canBeKilled() = false

    method updateCurrentProvider(){ 
        self.imageProviderSetUse(imageHandler.imageProviderKey()) 
        imageProviderSet.checked()
    }

    method useDefaultProvider() {
        if(not usingDefaultImageProvider){
            self.imageProviderSetUse(defaultImageProviderKey)
            usingDefaultImageProvider = true
        }
    }
    method imageProviderSetUse(key){
        usingDefaultImageProvider = false
        const provider = imageProviderSet.get(key)
        imageHandler.imageProvider(provider, key)
    }

    method entitiesAtOwnLine() =
        (config.lowerBound().x() .. config.upperBound().x()).map({ x =>
        game.at(x, position.y()).allElements()
        }).flatten()

    method animationEnded(){ 
        animationCallback.apply() 
        self.animationCallback({=>})
    }

    method animate() = imageHandler.update(self)

    method image() = imageHandler.getImage()
}

mixin Ticks{
    method outDatedCollisions()
    method imageProviderSet()
    method updateCurrentProvider()

    method tick(){ 
        self.outDatedCollisions() 
        if(self.imageProviderSet().shouldCheck()){
            self.updateCurrentProvider()
        }
    }

    override method start(pos){
        super(pos)
        entityTickingManager.addForAll(self)
    }
    override method cleanUp(){
        entityTickingManager.remove(self)
        super()
    }

}

mixin Active inherits Ticks{
    const actionModule 
    method actionModule() = actionModule

    method imageHandler()
    method imageProviderSetUse(key)
    method useDefaultProvider()

    method updateImageProvider(){
        const actionProviderKey = actionModule.getImageProviderKey(self)
        if(actionProviderKey != null){
            self.imageProviderSetUse(actionProviderKey)
        }else{
            self.useDefaultProvider()
        }
    }

    method anticipateBehavior(behaviorImageProvider){ 
        self.imageHandler().useTempAnimation(behaviorImageProvider, 1)
    }
    override method tick(){
        super()
        actionModule.use(self)
        self.updateImageProvider()
    }
}

mixin HandlesCollisions inherits Ticks{
    var property collitionHandler

    method collidingEntities()
    method position()

    override method position(newPosition){
        super(newPosition)
        self.outDatedCollisions()
        self.handleCollisions()
    }

    override method tick(){
        self.handleCollisions()
        super()
    }

    method handleCollisions(){
        self.collidingEntities().forEach({ e =>
            collitionHandler.apply(e)
        })
    }
}

mixin Alive{
    var property maxHealth
    var property deathHandler

    var thresholdHandler = noThreshold
    method changeThresholds(newThresholds){
        thresholdHandler = newThresholds
    }

    var property health = maxHealth
    method health(newHealth){
        health = newHealth
        if(not self.lives()){
            deathHandler.apply(self)
        }else{
            thresholdHandler.checkThreshold(self)
        }
    }

    method healthPercentage() = health/maxHealth

    override method canBeKilled() = true

    method lives() = health > 0
    method takeDamage(damage) { self.health(health-damage) }
}

object noThreshold{
    method checkThreshold(user){}
}

class HealthThreshold{
    const thresholds = []
    method checkThreshold(user){
        if(not thresholds.isEmpty() && thresholds.head().check(user)){
            thresholds.head().activate(user)
            thresholds.remove(thresholds.head())
        }
    }
}

class Threshold{
    const change
    const condition
    method check(user) = condition.check(user)
    method activate(user){ change.apply(user) }
}

class PercentageCondition{
    const percentage
    method check(user) = user.healthPercentage() <= percentage
}
class AmountCondition{
    const amount
    method check(user) = user.health() <= amount
}