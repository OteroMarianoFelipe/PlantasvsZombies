import zombies.zombie.*
import imageProvider.*
import imageProviderHandler.*
import entityTickingManager.*
import behavior.*
import util.config.*
import team.*

class Entity{
    var property team = neutralTeam
    const property imageHandler = new ImageProviderHandler( user = self, imageProvider = defaultImageProvider )
    
    var collides = false
    method collides() = collides

    method removeCollision(){ collides = false }
    method restoreCollision(){ collides = true }

    var property animationCallback = {=>}
    var property position = game.at(0,0)

    method blocksPlantPlacement() = false
    method blocksEnemyEntitiesMovement() = false
    method canBeKilled() = false

    var property defaultImageProvider = noImageProvider
    method defaultImageProvider(newImageProvider){
        if(newImageProvider != defaultImageProvider){
            defaultImageProvider =  newImageProvider 
        }
    }

    method allIntersectingElements() = position.allElements().filter({ e => e != self && e.collides()})
    method allCollidingEntities() = self.allIntersectingElements().filter({ e => e.collides() })
    method allEntitiesAtOwnLine() =
        (config.lowerBound().x() .. config.upperBound().x()).map({ x =>
        game.at(x, position.y()).allElements()
        }).flatten()

    method imageProvider() =  imageHandler.imageProvider()
    method imageProvider(newImageProvider){
        imageHandler.imageProvider(newImageProvider)
    }

    method isEnemy(other) = team.isEnemy(other)

    method start(pos){
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
        self.imageProvider(defaultImageProvider) 
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
    var property actionModule 

    method imageHandler()

    method anticipateBehavior(behaviorImageProvider){ 
        self.imageHandler().useTempAnimation(behaviorImageProvider, 1)
    }
    override method tick(){
        super()
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