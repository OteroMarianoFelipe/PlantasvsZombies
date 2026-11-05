import util.config.*
import assets.zombies.*
import util.debugger.*

class ImageProvider{
    method transitionSeamlessly(previousAnimation)
    method update(caller)
    method getImage()
    method durationInTicks()
    method durationInSeconds()
    method durationInAnimationTicks()
}

class StaticAnimation inherits ImageProvider{
    const property image

    override method durationInTicks() = 0
    override method durationInSeconds() = 0
    override method durationInAnimationTicks() = 0

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

    method canTransitionSeamlessly(previousAnimation) = previousAnimation.framesInAnimation() == framesInAnimation && previousAnimation.animationTicksPerFrame() <= animationTicksPerFrame
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

    override method durationInAnimationTicks() = animationTicksPerFrame*framesInAnimation
    override method durationInTicks() = config.secondsToTicks(durationInSeconds)

    method frameNumber001Format(){
        if(animationFrameNumber<10){
            return "00"+animationFrameNumber
        }
        if(animationFrameNumber<100){
            return "0"+animationFrameNumber
        }
        return ""+animationFrameNumber
    }

    override method getImage() = "animations/"+self.animationDirectory()+"/frame_"+self.frameNumber001Format()+".png"
}

class HealthBasedImageProvider inherits ImageProvider{
    var property imageProviderSet
    var property currentProviderIndex = 0
 
    method currentImageProvider() = imageProviderSet.get(currentProviderIndex)

    override method transitionSeamlessly(previousAnimation){}
    override method update(caller){
        var imageProvider = self.currentImageProvider()
        const updatedProviderIndex = (caller.health()/caller.maxHealth()*imageProviderSet.size()).roundUp(0)-1
        if(updatedProviderIndex != currentProviderIndex){
            const previousImageProvider = self.currentImageProvider()
            imageProvider = imageProviderSet.get(updatedProviderIndex)
            imageProvider.transitionSeamlessly(previousImageProvider)
            currentProviderIndex = updatedProviderIndex
        }
        imageProvider.update(caller)
    }
    override method getImage() = imageProviderSet.get(currentProviderIndex).getImage() 
    override method durationInTicks() = self.currentImageProvider().durationInTicks() 
    override method durationInSeconds() = self.currentImageProvider().durationInSeconds()
    override method durationInAnimationTicks() = self.currentImageProvider().durationInAnimationTicks()
}

object noImageProvider inherits StaticAnimation(image = "sprites/missingTexture.png"){}