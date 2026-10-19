import entityManager.*
import animation.*
import util.debugger.debugger

class Entity{
    var property position = game.at(0,0)
    var property previousPosition = self.position()

    method blocksOwnCell()=false

    method team()
    method canBeKilled() = false

    method start(pos){
        self.position(pos)
        game.addVisual(self)
    }
    method beClicked(){}
    method tick()
    method avanzar(){
        entitiesMap.updatePosition(self, self.previousPosition())
        self.previousPosition(self.position())
    }
    method stop(){
        entityManager.deleteEntity(self)
        game.removeVisual(self)
    }


    method image() = self.animationHandler().getImage()

    var property animation = self.defaultAnimation()
    method defaultAnimation() = noAnimation

    const property animationHandler = self.newAnimationHandler()
    method newAnimationHandler() = new AnimationHandler(owner = self)

    method changeAndUseDefaultAnimation(newAnimation){
        self.changeDefaultAnimation(newAnimation)
        self.changeCurrentAnimation(newAnimation)
    }
    method changeDefaultAnimation(newAnimation) { if(newAnimation != animation){ animation = newAnimation } }
    method changeCurrentAnimation(newAnimation) { self.animationHandler().changeAnimation(newAnimation) }
    method useDefaultAnimation(){ self.changeCurrentAnimation(self.animation()) }
    method resumeDefaultAnimation() { self.useDefaultAnimation() }

    method animate() = animationHandler.tickAnimation()

}