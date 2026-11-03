import zombies.zombie.*
import imageProvider.*
import entityManager.*
import behavior.*
import util.debugger.*

class Entity{
    var property team

    var property animationCallback = {=>}
    var property position = game.at(0,0)
    var property previousPosition = self.position()

    method blocksPlantPlacement() = false
    method blocksEnemyEntitiesMovement() = false
    method canBeKilled() = false

    var defaultImageProvider = noImageProvider
    method defaultImageProvider() = defaultImageProvider
    method defaultImageProvider(newImageProvider){
        if(newImageProvider != defaultImageProvider){
            defaultImageProvider =  newImageProvider 
        }
    }

    var imageProvider = defaultImageProvider
    method imageProvider() = imageProvider
    method imageProvider(newImageProvider){
        imageProvider = newImageProvider
        return newImageProvider
    }

    method isEnemy(other) = other.team()!=self.team() && other.team()!="NEUTRAL"

    method start(pos){
        self.position(pos)
        game.addVisual(self)
    }

    method beClicked(){}
    method cleanUp(){
        entityManager.removeEntity(self)
        game.removeVisual(self)
    }

    method updatePosition(newPosition){
        self.previousPosition(position)
        self.position(newPosition)        
        self.updateMapPosition()
    }
    method updateMapPosition(){
        entitiesMap.updatePosition(self)
        self.previousPosition(self.position())
    }
   
    method imageProviderSeamlessly(newImageProvider){
        newImageProvider.transitionSeamlessly(imageProvider)
        return self.imageProvider(newImageProvider)
    }

    method animationEnded(){ animationCallback.apply() }
    method endNonLoopingAnimation() { self.useDefaultImageProvider() }
    method useDefaultImageProvider(){ imageProvider = defaultImageProvider }
    method changeAndUseDefaultImageProvider(newImageProvider){
        self.defaultImageProvider(newImageProvider)
        self.useDefaultImageProvider()
    }

    method animate() = imageProvider.update(self)

    method image() = imageProvider.getImage()
}

mixin Alive{
    var property startingHealth
    var property health = startingHealth

    var property deathHandler

    override method canBeKilled() = true

    method lives() = health > 0
    method takeDamage(damage) {
        health = 0.max(health - damage)
        if(not self.lives()){
            deathHandler.apply(self)
        }
    }
}

mixin Ticks{
    method tick(){}

    override method start(pos){
        super(pos)
        entityManager.add(self)
    }
}

mixin Collides{
    override method start(pos){
        super(pos)
        entitiesMap.add(self)
    }
}

mixin ActiveEntity{
    var property actionModule 

    method imageProvider(newImageProvider)

    method anticipateBehavior(behaviorImageProvider){ self.imageProvider(behaviorImageProvider) }
    override method tick(){
        super()
        actionModule.use(self)
    }
}

class ActionModule{
    method use(user){}
}

mixin Shooter {
    var property shotsPerSecond
    var property proyectileGenerator
    var property shootingAnticipationAnimation

    var property shootingBehavior = 
        new ShootingBehavior(
            secondsPerUse = 1/shotsPerSecond,
            createNewProyectileInstance = { user => proyectileGenerator.apply(user) },
            anticipationAnimation = shootingAnticipationAnimation
        )

    method hasEnemyInSight(user){
        const entitiesInLine = entitiesMap.allEntitiesAtLine(user.position().y())
        return entitiesInLine.any({ entity => user.isEnemy(entity) })
    }
}
mixin ConditionedShooter inherits Shooter{
    override method use(user){
        super(user)
        if(self.hasEnemyInSight(user)){
            shootingBehavior.use(user)
        }
    }
}
mixin UnconditionalShooter inherits Shooter{
    override method use(user){
        super(user)
        shootingBehavior.use(user)
    }
}

mixin MeleeAttack{
    var property meleeDamage
    var property meleeAttacksPerSecond

    var property meleeAttackingBehavior = new MeleeAttackBehavior( secondsPerUse = 1/meleeAttacksPerSecond ) 

    method hasAttackObjective(user) = entitiesMap.allEntitiesAt(user.position()).any({ e => user.isEnemy(e) && e.canBeKilled()})

    override method use(user){
        super(user)
        if(self.hasAttackObjective(user)){
            meleeAttackingBehavior.use(user)
        }
    }
}

mixin Mobile{
    var property cellsPerSecond
    var property movingDirection

    var property movingBehavior = 
        new MovingBehavior(
            secondsPerUse = 1/cellsPerSecond,
            movingDirection = movingDirection
        )
    
    method hasObstacle(user){
        return entitiesMap.allEntitiesAt(user.position()).any({ entity =>
            user.isEnemy(entity) && entity.blocksEnemyEntitiesMovement()
        })
    }

    override method use(user){
        super(user)
        if(not self.hasObstacle(user)){
            movingBehavior.use(user)
        }else{
            debugger.info("Se determino que hay un obstaculo")
        }
    }
}


// Para que logre usarse tanto al inicio como al final debe ser como primer mixin
mixin Collide{
    const property collitionBehavior = new CollitionBehavior()

    override method use(user){
        collitionBehavior.use(user)
        super(user)
        collitionBehavior.use(user)
    }
}