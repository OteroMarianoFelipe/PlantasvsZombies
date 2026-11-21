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
    
    var imageProviderSet
    method imageProviderSet() = imageProviderSet
    
    var collides = false
    method collides() = collides

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

    method blocksPlantPlacement() = false
    method blocksEnemyMovement() = false
    method canBeKilled() = false

    method defaultProvider() = imageProviderSet.get(defaultImageProviderKey)
    method useDefaultProvider() { imageHandler.imageProvider(self.defaultProvider()) }
    method imageProviderSetUse(key){
        const provider = imageProviderSet.get(key)
        if(provider == null){
            debugger.warning("Proveedor no encontrado")
        }else{
            imageHandler.imageProvider(provider)
        }
    }

    method intersectingElements() = position.allElements().filter({ e => e != self && e.collides()})
    method collidingEntities() = self.intersectingElements().filter({ e => e.collides() })
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
    method tick(){}

    override method start(pos){
        super(pos)
        entityTickingManager.add(self)
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
    method defaultImageProviderKey()

    method updateImageProvider(){
        const actionProvider = actionModule.getImageProvider(self)
        if(actionProvider != null){
            self.imageHandler().imageProvider(actionProvider)
        }else{
            self.imageProviderSetUse(self.defaultImageProviderKey())
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

    override method position(newPosition){
        super(newPosition)
        self.handleCollitions()
    }

    override method tick(){
        self.handleCollitions()
        super()
    }

    method handleCollitions(){
        self.collidingEntities().forEach({ e =>
            collitionHandler.apply(e)
        })
    }
}