import util.config.*
import assets.zombie.*

class ImageProvider{
    method transitionSeamlessly(previousAnimation)
    method update(caller)
    method getImage()
    method durationInTicks()
}

class StaticAnimation inherits ImageProvider{
    const property image

    override method durationInTicks() = 0

    override method transitionSeamlessly(previousImageProvider){}
    override method update(caller){}
    override method getImage() = image
}

class Animation inherits ImageProvider{
    const property loop
    const property durationInSeconds
    const property framesInAnimation
    const property animationDirectory

    var property ticksInAnimationFrame = 0
    var property animationFrameNumber = 1

    const property animationTicksPerFrame = config.secondsToAnimationTicks(durationInSeconds)/framesInAnimation

    method canTransitionSeamlessly(pA) = pA.framesInAnimation() != framesInAnimation && pA.ticksInAnimationFrame() <= animationTicksPerFrame
    override method transitionSeamlessly(previousAnimation){
        if( self.canTransitionSeamlessly(previousAnimation)){
            ticksInAnimationFrame = previousAnimation.ticksInAnimationFrame()
            animationFrameNumber = previousAnimation.animationFrameNumber()
        }
    }

    method tickUpFrameTime() { ticksInAnimationFrame += 1 }
    method isTimeToPassFrame() = ticksInAnimationFrame >= animationTicksPerFrame
    method changeFrameIndex(caller){ 
        animationFrameNumber %= framesInAnimation
        if(animationFrameNumber == 0){
            caller.animationEnded()
            if( not loop ){
                caller.endNonLoopingAnimation()
            }
        }
        animationFrameNumber += 1
    }

    override method update(caller){
        if(self.isTimeToPassFrame()){
            self.changeFrameIndex(caller)
            ticksInAnimationFrame = 0
        }else{
            self.tickUpFrameTime()
        }
    }

    method durationInAnimationTicks() = animationTicksPerFrame*framesInAnimation
    override method durationInTicks() = config.secondsToTicks(durationInSeconds)

    method frameNumber001Format(){
        if(animationFrameNumber<10){
            return "00"+animationFrameNumber
        }
        if(animationFrameNumber<100){
            return "0"+animationFrameNumber
        }
        return animationFrameNumber
    }

    override method getImage() = "animations/"+self.animationDirectory()+"/frame_"+self.frameNumber001Format()+".png"
}

object noImageProvider inherits StaticAnimation(image = "sprites/missingTexture.png"){}

class AnimationHandler{
    var property imageProvider 

    method update(user) { imageProvider.update(user) }
    method getImage() = imageProvider.getImage()

    method changeImageProviderSeamlessly(newAnimation){
        newAnimation.transitionSeamlessly(imageProvider)
        return self.changeImageProvider(newAnimation)
    }
    method changeImageProvider(newAnimation){
        self.imageProvider(newAnimation)
        return newAnimation
    }
}