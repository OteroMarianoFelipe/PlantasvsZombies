import imageProvider.*
import util.debugger.*

class ImageProviderStateTracker{
    var ticksInFrame = 1
    method ticksInFrame() = ticksInFrame
    var animationEnded = false
    method animationEnded() = animationEnded

    var property frameNumber = 1
    method frameNumber(newFrameNumber){
        self.resetTicksInFrame()
        frameNumber = newFrameNumber
        if(frameNumber == 1){
            animationEnded = true
        }else{
            animationEnded = false
        }
    }
    
    method resetTracker(){
        animationEnded = false
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
    var tempImageProvider = noImageProvider
    const stateTracker = new ImageProviderStateTracker()

    method currentProvider() = if(self.onTempAnimation()) tempImageProvider else imageProvider

    var imageProvider
    method imageProvider() = imageProvider
    method imageProvider(newImageProvider, key){
        if(imageProvider == newImageProvider){return}
        imageProviderKey = key
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
    var imageProviderKey = null
    method imageProviderKey() = imageProviderKey

    method exitTempAnimation(){
        if(self.onTempAnimation()){
            timesToUseTempAnimation = 0
            self.restoreFromTemporaryAnimation()
        }
    }

    method onTempAnimation() = timesToUseTempAnimation > 0
    method useTempAnimation(tempAnimation, times){
        if(tempImageProvider != tempAnimation){
            stateTracker.resetTracker()
            timesToUseTempAnimation = times
            tempImageProvider = tempAnimation
        }
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

    method update(user){ 
        self.currentProvider().update(stateTracker) 
        if(stateTracker.animationEnded()){
            self.checkTemporaryAnimationState()
            user.animationEnded() 
        }
    }

    method getImage() = self.currentProvider().getImage(stateTracker)
}