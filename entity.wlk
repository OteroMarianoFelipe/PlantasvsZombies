import zombies.zombieBase.*
import entityManager.*
import imageProvider.*
import behavior.*
import util.debugger.*

class Entity{
    var property team

    var property defaultImageProvider = noImageProvider
    var property imageProvider = defaultImageProvider
    var property animationCallback = {=>}
    var property position = game.at(0,0)
    var property previousPosition = self.position()

    method tick()

    method blocksPlantPlacement() = false
    method blocksEnemyEntitiesMovement() = false
    method canBeKilled() = false
    method animationEnded(){ animationCallback.apply() }

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
   
    method changeImageProviderSeamlessly(newImageProvider){
        newImageProvider.transitionSeamlessly(imageProvider)
        return self.changeImageProvider(newImageProvider)
    }
    method changeImageProvider(newImageProvider){
        self.imageProvider(newImageProvider)
        return newImageProvider
    }

    method endNonLoopingAnimation() { self.useDefaultImageProvider() }
    method useDefaultImageProvider(){ imageProvider = defaultImageProvider }
    method changeDefaultImageProvider(newImageProvider) { if(newImageProvider != defaultImageProvider){ defaultImageProvider =  newImageProvider } }
    method changeAndUseDefaultImageProvider(newImageProvider){
        self.changeDefaultImageProvider(newImageProvider)
        self.useDefaultImageProvider()
    }

    method animate() = imageProvider.update(self)

    method image() = imageProvider.getImage()
}

mixin Alive{
    var property startingHealth
    var property health = startingHealth

    method handleDeath()

    override method canBeKilled() = true

    method lives() = health > 0
    method takeDamage(damage) {
        health = 0.max(health - damage)
        if(not self.lives()){
            self.handleDeath()
        }
    }
}

mixin ActiveEntity{
    var property actionModule 

    method changeImageProvider(newImageProvider)

    method anticipateBehavior(behaviorImageProvider){ self.changeImageProvider(behaviorImageProvider) }
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