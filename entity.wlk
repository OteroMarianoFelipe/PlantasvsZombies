import entityManager.*
import animation.*


class Entity{
    var property position = game.at(0,0)
    var property previousPosition = self.position()

    method blocksOwnCell()=false
    method canBeKilled() = false

    method team()
    method tick()
    method handleOwnRemoval()

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

    const property animationHandler = self.newAnimationHandler()
    method newAnimationHandler() = new AnimationHandler(owner = self)

    var property animation = self.defaultAnimation()
    method defaultAnimation() = noAnimation

    method image() = self.animationHandler().getImage()
   
    method useDefaultAnimation(){ animationHandler.changeAnimation(self.animation()) }
    method changeDefaultAnimation(newAnimation) { if(newAnimation != animation){ animation = newAnimation } }
    method changeAndUseDefaultAnimation(newAnimation){
        self.changeDefaultAnimation(newAnimation)
        self.useDefaultAnimation()
    }

    method endNonLoopingAnimation() { self.useDefaultAnimation() }

    method animate() = animationHandler.tickAnimation()

}