import entityManager.*
import animation.*


class Entity{
    var property blocksOwnCell
    var property canBeKilled
    var property team

    var property defaultImageProvider = noImageProvider
    var property imageProvider = defaultImageProvider
    var property animationCallback = {=>}
    var property position = game.at(0,0)
    var property previousPosition = self.position()

    method tick()

    method animationEnded(){ animationCallback.apply() }

    method start(pos){
        self.position(pos)
        game.addVisual(self)
    }
    method beClicked(){}
    method updateMapPosition(){
        entitiesMap.updatePosition(self, self.previousPosition())
        self.previousPosition(self.position())
    }
    method cleanUp(){
        entityManager.removeEntity(self)
        game.removeVisual(self)
    }

    method updatePosition(newPosition){
        self.previousPosition(position)
        self.position(newPosition)        
        self.updateMapPosition()
    }
   
    method changeImageProviderSeamlessly(newImageProvider){
        newImageProvider.transitionSeamlessly(imageProvider)
        return self.changeImageProvider(newImageProvider)
    }
    method changeImageProvider(newImageProvider){
        self.imageProvider(newImageProvider)
        return newImageProvider
    }

    method endNonLoopingAnimation() { self.useDefaultImageProvider() }
    method useDefaultImageProvider(){ imageProvider = defaultImageProvider }
    method changeDefaultImageProvider(newImageProvider) { if(newImageProvider != defaultImageProvider){ defaultImageProvider =  newImageProvider } }
    method changeAndUseDefaultImageProvider(newImageProvider){
        self.changeDefaultImageProvider(newImageProvider)
        self.useDefaultImageProvider()
    }

    method animate() = imageProvider.update(self)

    method image() = imageProvider.getImage()
}