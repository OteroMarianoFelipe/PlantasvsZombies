import util.config.*

class ImageProviderHandler{
    var timesToUseTempAnimation = 0
    var imageProviderToRestoreTo = noImageProvider

    method noFamily(imgProv) = imgProv.family() == null
    method sameFamily(imgProv1, imgProv2) = imgProv1.family() == imgProv2.family()

    var imageProvider
    method imageProvider() = imageProvider
    method imageProvider(newImageProvider){
        if(imageProvider == newImageProvider){return}
        if(
            self.noFamily(newImageProvider) || 
            not self.sameFamily(imageProvider, newImageProvider) 
        ){
            frameNumber = 1
            ticksInFrame = 1
        }
        imageProvider = newImageProvider
        return
    }

    method useTempAnimation(tempAnimation, times){
        timesToUseTempAnimation = times
        imageProviderToRestoreTo = imageProvider
        self.imageProvider(tempAnimation)
    }
    method restoreFromTemporaryAnimation(){
        self.imageProvider(imageProviderToRestoreTo)
        imageProviderToRestoreTo = noImageProvider
    }
    method checkForTemporaryAnimation(){
        if (timesToUseTempAnimation > 0){
            timesToUseTempAnimation-=1
            if(timesToUseTempAnimation == 0){
                self.restoreFromTemporaryAnimation()
            }
        }
    }

    var frameNumber = 1
    method frameNumber() = frameNumber
    var ticksInFrame = 1
    method ticksInFrame() = ticksInFrame

    method tickUpInFrameTime(){ ticksInFrame+=1 }
    method changeFrameNumber(user, newFrameNumber){
        ticksInFrame = 1
        frameNumber = newFrameNumber
        if(frameNumber == 1){ 
            self.checkForTemporaryAnimation()
            user.animationEnded() 
        }
    }

    method update(user){ imageProvider.update(user, self) }

    method getImage(user) = imageProvider.getImage(user, self)
}

class ImageProvider{
    const property family = null
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
            traker.changeFrameNumber(user, newFrameNumber)
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