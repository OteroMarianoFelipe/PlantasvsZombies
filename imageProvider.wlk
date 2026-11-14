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
    const property durationInTicks = imageProviderSet.average({p=>p.durationInTicks()}).truncate(0)

    method getIndexFromHealth(user) = (user.health()/user.maxHealth()*imageProviderSet.size()).roundUp(0)-1

    method imageProvider(user) = imageProviderSet.get(self.getIndexFromHealth(user))

    override method update(user, traker){
        self.imageProvider(user).update(user, traker)
    }   
    override method getImage(user, traker) = self.imageProvider(user).getImage(user, traker) 
}

object noImageProvider inherits Sprite(image = "sprites/missingTexture.png"){}

class KeyProviderPair{
    const property key
    var property provider
}

class ImageProviderSet{
    const entries = #{}

    method hasKey(key) = entries.map({ p => p.key() }).findOrDefault({ k => k == key  }, null) != null

    method get(key){
        if( not self.hasKey(key)){
            self.addEntry(key)
        }
        return entries.find({ pair => pair.key() == key })
    }
    method addEntry(key){ self.addEntry(key, null) }
    method addEntry(key, provider){
        if( self.hasKey(key) ){
            debugger.warning("Key "+key+" allready in use")
        }
        entries.add( new KeyProviderPair(key = key, provider = provider) )
    }

    method removeEntry(key){ entries.remove(self.get(key)) }
    method getProvider(key) = self.get(key).provider()

    method pairForProvider(provider) = entries.findOrDefault({ pair => pair.provider() == provider }, null)
    method keyFor(provider){
        const result = self.pairForProvider(provider)
        if(result == null){ return null }
        return result.key()
    }

    method modifyProvider(key, provider){ 
        self.get(key).provider(provider) 
    }
}

object noImageProviderSet{
    method getProvider(key) = null
}