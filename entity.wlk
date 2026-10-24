import entityManager.*
import animation.*


class Entity{
    var property animation = noAnimation
    var property blocksOwnCell
    var property canBeKilled
    var property team

    var property animationCallback = {=>}
    var property position = game.at(0,0)
    var property previousPosition = self.position()

    method tick()

    method animationEnded(){ animationCallback.apply() }

    method start(pos){
        self.position(pos)
        game.addVisual(self)
    }
    method beClicked(){}
    method updateMapPosition(){
        entitiesMap.updatePosition(self, self.previousPosition())
        self.previousPosition(self.position())
    }
    method cleanUp(){
        entityManager.removeEntity(self)
        game.removeVisual(self)
    }

    method updatePosition(newPosition){
        self.previousPosition(position)
        self.position(newPosition)        
        self.updateMapPosition()
    }

    const property animationHandler = self.newAnimationHandler()
    method newAnimationHandler() = new AnimationHandler(imageProvider = animation)


    method image() = self.animationHandler().getImage()
   
    method useDefaultImageProvider(){ animationHandler.changeImageProvider(self.animation()) }
    method changeDefaultImageProvider(newAnimation) { if(newAnimation != animation){ animation = newAnimation } }
    method changeAndUseDefaultImageProvider(newAnimation){
        self.changeDefaultImageProvider(newAnimation)
        self.useDefaultImageProvider()
    }

    method endNonLoopingAnimation() { self.useDefaultImageProvider() }

    method animate() = animationHandler.update(self)

}