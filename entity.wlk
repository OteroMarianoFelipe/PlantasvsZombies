import zombies.zombie.*
import imageProvider.*
import entityManager.*
import behavior.*
import util.debugger.*

class Entity{
    var property team
    const property imageHandler = new ImageProviderHandler( imageProvider = defaultImageProvider )

    var property animationCallback = {=>}
    var property position = game.at(0,0)
    var property previousPosition = self.position()

    method blocksPlantPlacement() = false
    method blocksEnemyEntitiesMovement() = false
    method canBeKilled() = false

    var property defaultImageProvider = noImageProvider
    method defaultImageProvider(newImageProvider){
        if(newImageProvider != defaultImageProvider){
            defaultImageProvider =  newImageProvider 
        }
    }

    method imageProvider() =  imageHandler.imageProvider()
    method imageProvider(newImageProvider){
        imageHandler.imageProvider(newImageProvider)
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

    method animationEnded(){ 
        animationCallback.apply() 
        self.animationCallback({=>})
    }
    method useDefaultImageProvider(){ 
        self.imageProvider(defaultImageProvider) 
    }

    method animate() = imageHandler.update(self)

    method image() = imageHandler.getImage(self)
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

    method imageHandler()

    method anticipateBehavior(behaviorImageProvider){ 
        self.imageHandler().useTempAnimation(behaviorImageProvider, 1)
    }
    override method tick(){
        super()
        actionModule.use(self)
    }
}

class ActionModule{
    var stopped = false

    method stop(){ stopped = true }
    method isStopped() = stopped

    method use(user){
        if(not stopped){
            self.act(user, entitiesMap.allIntersectingEntities(user))
        }
    }

    method act(user, touching){}
    method slowDown(factor){}
    method restoreSpeed(){}
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

    override method slowDown(factor){
        super(factor)
        shootingBehavior.slowDown(factor)
    }

    override method restoreSpeed(){
        super()
        shootingBehavior.restoreSpeed()
    }
}
mixin ConditionedShooter inherits Shooter{
    override method act(user, touching){
        super(user, touching)
        if(self.hasEnemyInSight(user)){
            shootingBehavior.use(user)
        }
    }
}
mixin UnconditionalShooter inherits Shooter{
    override method act(user, touching){
        super(user, touching)
        shootingBehavior.use(user)
    }
}

mixin MeleeAttack{
    var property meleeDamage
    var property meleeAttacksPerSecond

    var property meleeAttackingBehavior =
        new MeleeAttackBehavior(
            secondsPerUse = 1/meleeAttacksPerSecond,
            damage = meleeDamage
        )

        // De todas las entidades con las que choca, el objetivo es el primer enemigo que se puede matar
    method attackObjective(user, touching) =
        touching.findOrDefault({ e => user.isEnemy(e) && e.canBeKilled() }, null)

    override method act(user, touching){
        super(user, touching)
        const objective = self.attackObjective(user, touching)
        if(objective != null){
            meleeAttackingBehavior.objective(objective)
            meleeAttackingBehavior.use(user)
        }
    }

    override method slowDown(factor){
        super(factor)
        meleeAttackingBehavior.slowDown(factor)
    }

    override method restoreSpeed(){
        super()
        meleeAttackingBehavior.restoreSpeed()
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
    
    method hasObstacle(user, touching){
        return touching.any({ entity =>
            user.isEnemy(entity) && entity.blocksEnemyEntitiesMovement()
        })
    }

    override method act(user, touching){
        super(user, touching)
        if(not self.hasObstacle(user, touching)){
            movingBehavior.use(user)
        }
    }

    override method slowDown(factor){
        super(factor)
        movingBehavior.slowDown(factor)
    }

    override method restoreSpeed(){
        super()
        movingBehavior.restoreSpeed()
    }    
}


// Opcional: solo lo usan las entidades que tienen que reaccionar al chocar como las arvejas
mixin HandlesCollisions{
    method isStopped()

    override method act(user, touching){
        touching.forEach({ entity =>
            if(not self.isStopped()){ user.collisionHandler(entity) }
        })
        if(not self.isStopped()){
            super(user, touching)
        }
    }
}