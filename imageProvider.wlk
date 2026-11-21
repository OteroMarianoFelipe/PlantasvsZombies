import zombies.zombieBasico.*
import util.debugger.*
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
    const image

    override method update(user, traker){}
    override method durationInTicks() = 0
    override method getImage(user, traker) = image
}

class Animation inherits ImageProvider{
    const durationInSeconds
    const framesInAnimation
    const animationDirectory

    method animationTicksPerFrame() = (config.secondsToAnimationTicks(durationInSeconds)/framesInAnimation).truncate(0)
    override method durationInTicks() = config.secondsToTicks(durationInSeconds)

    method isTimeToPassFrame(traker) = traker.ticksInFrame() >= self.animationTicksPerFrame()
    method newFrameNumber(previous) = (previous % framesInAnimation) +1

    override method update(user, traker){
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

    override method getImage(user, traker) = "animations/"+animationDirectory+"/frame_"+self.frameNumber001Format(traker.frameNumber())+".png"
}

class HealthBasedImageProvider inherits ImageProvider{
    const imageProviderSet    
    const property durationInTicks = imageProviderSet.average({p=>p.durationInTicks()}).truncate(0)

    method getIndexFromHealth(user) = ((user.health()/user.maxHealth()*imageProviderSet.size()).roundUp(0)-1).max(0)

    method imageProvider(user) = imageProviderSet.get(self.getIndexFromHealth(user))

    override method update(user, traker){
        self.imageProvider(user).update(user, traker)
    }   
    override method getImage(user, traker) = self.imageProvider(user).getImage(user, traker) 
}

object noImageProvider inherits Sprite(image = "sprites/missingTexture.png"){}

class ImageProviderEntry{
    const property key
    const property value
}

class ImageProviderSet{
    const property entries = new Dictionary()
    method entries() = entries

    method initialize(startingEntries){
        startingEntries.forEach({ e =>
            entries.put(e.key(), e.value())
        })
        return self
    }

    method get(key) = entries.get(key)
    method add(key, value){ entries.put(key, value) }
    method remove(key){ entries.remove(key) }
}

object noImageProviderSet{
    method get(key) = null
}