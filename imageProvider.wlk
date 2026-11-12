import util.config.*

class ImageProvider{
    const property family = null

    method hasFamily() = family != null
    method sameFamily(otherProvider) = family == otherProvider.family()

    method update(user, traker)
    method getImage(user, traker)
    method durationInTicks()
}

class Sprite inherits ImageProvider{
    const property image

    override method update(user, traker){}
    override method durationInTicks() = 0
    override method getImage(user, traker) = image
}

class Animation inherits ImageProvider{
    const property durationInSeconds
    const property framesInAnimation
    const property animationDirectory

    const property animationTicksPerFrame = (config.secondsToAnimationTicks(durationInSeconds)/framesInAnimation).truncate(0)

    method isTimeToPassFrame(traker) = traker.ticksInFrame() >= animationTicksPerFrame
    method newFrameNumber(previous) = (previous % framesInAnimation) +1

    override method update(user, traker){
        if(self.isTimeToPassFrame(traker)){
            const newFrameNumber = self.newFrameNumber(traker.frameNumber())
            traker.frameNumber(newFrameNumber)
        }else{
            traker.tickUpInFrameTime()
        }
    }

    override method durationInTicks() = config.secondsToTicks(durationInSeconds)

    method frameNumber001Format(frameNumber){
        if (frameNumber<10) return "00"+frameNumber
        if (frameNumber<100) return "0"+frameNumber
        return frameNumber.toString()
    }

    override method getImage(user, traker) = "animations/"+animationDirectory+"/frame_"+self.frameNumber001Format(traker.frameNumber())+".png"
}



class HealthBasedImageProvider inherits ImageProvider{
    const imageProviderSet    

    method getIndexFromHealth(user) = (user.health()/user.startingHealth()*imageProviderSet.size()).roundUp(0)-1

    method imageProvider(user) = imageProviderSet.get(self.getIndexFromHealth(user))

    override method update(user, traker){
        self.imageProvider(user).update(user, traker)
    }   
    override method getImage(user, traker) = self.imageProvider(user).getImage(user, traker) 
    override method durationInTicks() = null 
}

object noImageProvider inherits Sprite(image = "sprites/missingTexture.png"){}