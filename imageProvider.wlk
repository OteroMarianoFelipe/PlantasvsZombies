import zombies.zombieBasico.*
import util.debugger.*
import util.config.*

class ImageProvider{
    const property family = null

    method hasFamily() = family != null
    method sameFamily(otherProvider) = family == otherProvider.family()

    method update(traker)
    method getImage(traker)
    method durationInTicks()
}

class Sprite inherits ImageProvider{
    const image

    override method update(traker){}
    override method durationInTicks() = 0
    override method getImage(traker) = image
}

class Animation inherits ImageProvider{
    const durationInSeconds
    const framesInAnimation
    const animationDirectory

    method animationTicksPerFrame() = (config.secondsToAnimationTicks(durationInSeconds)/framesInAnimation).truncate(0)
    override method durationInTicks() = config.secondsToTicks(durationInSeconds)

    method isTimeToPassFrame(traker) = traker.ticksInFrame() >= self.animationTicksPerFrame()
    method newFrameNumber(previous) = (previous % framesInAnimation) +1

    override method update(traker){
        if(self.isTimeToPassFrame(traker)){
            const newFrameNumber = self.newFrameNumber(traker.frameNumber())
            traker.frameNumber(newFrameNumber)
        }else{
            traker.tickUpInFrameTime()
        }
    }

    method frameNumber001Format(frameNumber){
        if (frameNumber<10) return "00"+frameNumber
        if (frameNumber<100) return "0"+frameNumber
        return frameNumber.toString()
    }

    override method getImage(traker) = "animations/"+animationDirectory+"/frame_"+self.frameNumber001Format(traker.frameNumber())+".png"
}

object noImageProvider inherits Sprite(image = "sprites/missingTexture.png"){}

class ImageProviderEntry{
    const property key
    const property value
}

class ImageProviderSet{
    const property entries = new Dictionary()
    method entries() = entries

    var changed = true

    method initialize(startingEntries){
        startingEntries.forEach({ e =>
            entries.put(e.key(), e.value())
        })
        return self
    }

    method shouldCheck() = changed
    method checked(){
        changed = false
    }

    method get(key) = entries.get(key)
    method add(key, value){
        changed = true
        entries.put(key, value) 
    }
    method remove(key){
        changed = true
        entries.remove(key) 
    }
}

object noImageProviderSet{
    method get(key) = null
}