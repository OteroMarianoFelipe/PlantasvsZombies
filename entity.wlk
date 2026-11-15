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
    var property imageProviderSet
    const property defaultImageProviderKey
    const property imageHandler = new ImageProviderHandler( user = self, imageProvider = noImageProvider )
    
    var collides = false
    method collides() = collides

    method removeCollision(){ collides = false }
    method restoreCollision(){ collides = true }

    method allObstacles() = self.allCollidingEntities().filter({ e => self.isEnemy(e) && e.blocksEnemyEntitiesMovement()})
    method hasObstacle() = self.allObstacles().size() > 0

    var property animationCallback = {=>}
    var property position = game.at(0,0)

    method blocksPlantPlacement() = false
    method blocksEnemyEntitiesMovement() = false
    method canBeKilled() = false

    method updateImageProvider(){}
    method imageProviderSetUse(key){
        const provider = imageProviderSet.get(key)
        if(provider == null){
            debugger.warning("Proveedor no encontrado")
        }else{
            self.imageProvider(provider)
        }
    }

    method allIntersectingElements() = position.allElements().filter({ e => e != self && e.collides()})
    method allCollidingEntities() = self.allIntersectingElements().filter({ e => e.collides() })
    method allEntitiesAtOwnLine() =
        (config.lowerBound().x() .. config.upperBound().x()).map({ x =>
        game.at(x, position.y()).allElements()
        }).flatten()

    method imageProvider() =  imageHandler.currentProvider()
    method imageProvider(newImageProvider){
        if(newImageProvider == null){ self.error("Un proveedor de imagen no puede ser nulo") }
        imageHandler.imageProvider(newImageProvider)
    }

    method isEnemy(other) = team.isEnemy(other)

    method start(pos){
        const set = imageProviderSet
        var diccionario = set.entries()
        var proveedor = diccionario.basicGet(defaultImageProviderKey)
        self.imageProvider(proveedor)
        self.position(pos)
        game.addVisual(self)
    }

    method beClicked(){}
    method cleanUp(){
        game.removeVisual(self)
    }

    method outOfBounds(){ self.cleanUp() }

    method animationEnded(){ 
        animationCallback.apply() 
        self.animationCallback({=>})
    }
    method useDefaultImageProvider(){ 
        self.imageProvider(imageProviderSet.provider(defaultImageProviderKey)) 
    }

    method animate() = imageHandler.update()

    method image() = imageHandler.getImage()
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

mixin Active{
    const actionModule 
    method actionModule() = actionModule

    method imageHandler()
    method imageProviderSetUse(key)
    method defaultImageProviderKey()
    method imageProvider(newImageProvider)

    override method updateImageProvider(){
        const actionProvider = actionModule.getImageProvider(self)
        if(actionProvider != null){
            self.imageProvider(actionProvider)
        }else{
            self.imageProviderSetUse(self.defaultImageProviderKey())
        }
    }

    method anticipateBehavior(behaviorImageProvider){ 
        self.imageHandler().useTempAnimation(behaviorImageProvider, 1)
    }
    override method tick(){
        super()
        self.updateImageProvider()
        actionModule.use(self)
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

    method allCollidingEntities()

    override method position(newPosition){
        super(newPosition)
        self.handleCollitions()
    }

    override method tick(){
        self.handleCollitions()
        super()
    }

    method handleCollitions(){
        self.allCollidingEntities().forEach({ e =>
            collitionHandler.apply(e)
        })
    }
}