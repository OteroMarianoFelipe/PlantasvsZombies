import entityManager.*
import animation.*


class Entity{
    var property animation = noAnimation
    var property blocksOwnCell
    var property canBeKilled
    var property team

    var property position = game.at(0,0)
    var property previousPosition = self.position()

    method tick()

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