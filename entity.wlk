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
    method hasObstacle() = self.obstacles().size() > 0

    method canBeKilled() = false

    method defaultProvider() = imageProviderSet.get(defaultImageProviderKey)
    method useDefaultProvider() { 
        if(not usingDefaultImageProvider){
            imageHandler.imageProvider(self.defaultProvider()) 
            usingDefaultImageProvider = true
        }
    }
    method imageProviderSetUse(key){
        usingDefaultImageProvider = false
        const provider = imageProviderSet.get(key)
        imageHandler.imageProvider(provider)
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

    method image() = imageHandler.getImage(self)
}

mixin Ticks{
    method outDatedCollisions()

    method tick(){ self.outDatedCollisions() }

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
    method useDefaultProvider()
    method evaluateCollisions()

    method updateImageProvider(){
        const actionProvider = actionModule.getImageProvider(self)
        if(actionProvider != null){
            self.imageHandler().imageProvider(actionProvider)
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

mixin Alive{
    var property maxHealth
    var property deathHandler

    var property health = maxHealth
    method health(newHealth){
        health = newHealth
        if(not self.lives()){
            deathHandler.apply(self)
        }
    }

    method healthPercentage() = health/maxHealth

    override method canBeKilled() = true

    method lives() = health > 0
    method takeDamage(damage) { self.health(health-damage) }
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