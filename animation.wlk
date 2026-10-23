import util.config.*
import assets.zombie.*

class Animation{
    const property loop
    const property durationInSeconds
    const property framesInAnimation
    const property animationDirectory

    const property ticksPerFrame = config.secondsToAnimationTicks(self.durationInSeconds())/self.framesInAnimation()
    method durationInTicks() = self.ticksPerFrame()*self.framesInAnimation()

    method getCurrentFrame(currentFrame001Format) = "animations/"+self.animationDirectory()+"/frame_"+currentFrame001Format+".png"
}

class AnimationHandler{
    var property animation = self.changeAnimation(owner.animation())
    var property owner
    var property ticksInAnimationFrame = 0
    var property animationFrameNumber = 1

    method tickUpFrameTime() { ticksInAnimationFrame+=1 }
    method isTimeToPassFrame() = ticksInAnimationFrame>=self.animation().ticksPerFrame()
    method changeFrameIndex(){ 
        animationFrameNumber %= self.animation().framesInAnimation()
        if(animationFrameNumber == 0){
            animationCallBack.apply()
            self.animationCallBack({ => })
            if(not self.animation().loop()){
                owner.endNonLoopingAnimation()
            }
        }
        animationFrameNumber += 1
    }

    var property animationTickBehavior = { => self.movingAnimationTick()}
    var property animationCallBack = { => }

    method movingAnimationTick(){
        if(self.isTimeToPassFrame()){
            self.changeFrameIndex()
            ticksInAnimationFrame = 0
        }else{
            self.tickUpFrameTime()
        }
    }
    method staticAnimationTick(){}

    method tickAnimation() = self.animationTickBehavior().apply()

    method frameNumber001Format(){
        if(animationFrameNumber<10){
            return "00"+animationFrameNumber
        }
        if(animationFrameNumber<100){
            return "0"+animationFrameNumber
        }
        return animationFrameNumber
    }

    method getImage() = self.animation().getCurrentFrame(self.frameNumber001Format())

    method resetAnimationStateTrackers(){
        self.ticksInAnimationFrame(0)
        self.animationFrameNumber(1)
    }
    method setAnimationTickBehavior(){
        if(animation.framesInAnimation() == 1){
            self.animationTickBehavior({=>self.staticAnimationTick()})
        }else{
            self.animationTickBehavior({=>self.movingAnimationTick()})
        }  
    }

    method changeAnimation(newAnimation) = self.changeAnimation(newAnimation, {=>})
    method changeAnimation(newAnimation, callback){
        self.resetAnimationStateTrackers()
        return self.changeAnimationSeamlessly(newAnimation, callback)
    }

    method changeAnimationSeamlessly(newAnimation) = self.changeAnimationSeamlessly(newAnimation, { => })
    method changeAnimationSeamlessly(newAnimation, callback){
        self.animation(newAnimation)
        self.setAnimationTickBehavior()
        self.animationCallBack(callback)
        return newAnimation
    }
}

class StaticAnimation{
    method durationInTicks() = 0
    method framesInAnimation() = 1
    const property ticksPerFrame = 0
    method isTimeToPassFrame() = false
    method tickAnimation() = false
    method getCurrentFrame(frameNumber) = self.image()
    const property img
    method image() = img
}

object noAnimation inherits StaticAnimation(img = "sprites/missingTexture.png"){}