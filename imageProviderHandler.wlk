import imageProvider.*

class ImageProviderStateTracker{
    var property ticksInFrame = 1
    const owner

    var property frameNumber = 1
    method frameNumber(newFrameNumber){
        self.resetTicksInFrame()
        frameNumber = newFrameNumber
        if(frameNumber == 1){
            owner.animationEnded()
        }
    }
    
    method resetTracker(){
        frameNumber = 1
        self.resetTicksInFrame()
    }
    method resetTicksInFrame(){
        ticksInFrame = 1
    }

    method tickUpInFrameTime(){ ticksInFrame+=1 }

}

class ImageProviderHandler{
    var timesToUseTempAnimation = 0
    var imageProviderToRestoreTo = noImageProvider
    const user

    const imageStateTracker = new ImageProviderStateTracker( owner = self )

    var imageProvider
    method imageProvider() = imageProvider
    method imageProvider(newImageProvider){
        if(imageProvider == newImageProvider){return}
        if(
            not newImageProvider.hasFamily() || 
            not imageProvider.sameFamily(newImageProvider) 
        ){
            imageStateTracker.resetTracker()
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
    method checkTemporaryAnimationState(){
        if (timesToUseTempAnimation > 0){
            timesToUseTempAnimation-=1
            if(timesToUseTempAnimation == 0){
                self.restoreFromTemporaryAnimation()
            }
        }
    }

    method animationEnded(){
        self.checkTemporaryAnimationState()
        user.animationEnded() 
    }

    method update(){ imageProvider.update(user, imageStateTracker) }

    method getImage() = imageProvider.getImage(user, imageStateTracker)
}