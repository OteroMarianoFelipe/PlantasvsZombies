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
    const user

    var timesToUseTempAnimation = 0
    var tempImageProvider = noImageProvider
    const stateTracker = new ImageProviderStateTracker( owner = self )

    method currentProvider() = if(self.onTempAnimation()) tempImageProvider else imageProvider

    var imageProvider
    method imageProvider() = imageProvider
    method imageProvider(newImageProvider){
        if(imageProvider == newImageProvider){return}
        if(
            not self.onTempAnimation() &&
            not newImageProvider.hasFamily() || 
            not imageProvider.sameFamily(newImageProvider)
        ){
            stateTracker.resetTracker()
        }
        imageProvider = newImageProvider
        return
    }

    method exitTempAnimation(){
        if(self.onTempAnimation()){
            timesToUseTempAnimation = 0
            self.restoreFromTemporaryAnimation()
        }
    }

    method onTempAnimation() = timesToUseTempAnimation > 0
    method useTempAnimation(tempAnimation, times){
        stateTracker.resetTracker()
        timesToUseTempAnimation = times
        tempImageProvider = tempAnimation
    }
    method restoreFromTemporaryAnimation(){
        stateTracker.resetTracker()
        tempImageProvider = noImageProvider
    }
    method checkTemporaryAnimationState(){
        if(self.onTempAnimation()){
            timesToUseTempAnimation-=1
            if(not self.onTempAnimation()){
                self.restoreFromTemporaryAnimation()
            }
        }
    }

    method animationEnded(){
        self.checkTemporaryAnimationState()
        user.animationEnded() 
    }

    method update(){ self.currentProvider().update(user, stateTracker) }

    method getImage() = self.currentProvider().getImage(user, stateTracker)
}