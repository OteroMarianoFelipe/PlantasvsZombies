import util.debugger.debugger
import util.config.*

class Animation{
    method loop()
    const property ticksPerFrame = self.durationInSeconds()*config.animationTicksPerSecond()/self.framesInAnimation()
    method durationInSeconds()
    method framesInAnimation()
    method animationDirectory()
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
        if(animationFrameNumber == 0 and not self.animation().loop()){
            owner.resumeDefaultAnimation()
        }
        animationFrameNumber += 1
    }

    var property animationTickBehavior = {=> self.movingAnimationTick()}

    method movingAnimationTick(){
        if(self.isTimeToPassFrame()){
            self.changeFrameIndex()
            ticksInAnimationFrame = 0
            return true
        }else{
            self.tickUpFrameTime()
            return false
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

    method changeAnimation(newAnimation){
        self.ticksInAnimationFrame(0)
        self.animationFrameNumber(1)
        self.animation(newAnimation)
        if(newAnimation.framesInAnimation() == 1){
            self.animationTickBehavior({=>self.staticAnimationTick()})
        }else{
            self.animationTickBehavior({=>self.movingAnimationTick()})
        }   
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