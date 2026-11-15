import imageProviderHandler.*
import entity.*
import player.player
import plantas.lanzaguisantes.*
import plantas.girasol.Girasol
import plantas.nuez.Nuez
import plantas.snowPea.SnowPea
import entityTickingManager.*
import UIElements.sunCounter.sunCounter
import imageProvider.*

class PlantCard inherits Ticks and Entity(
    defaultImageProviderKey =  "#Available"
){
    const property price
    const property createNewInstance

    var isAvailable = false
    var plantBuyCoolDown = false

    method reset(){
        imageHandler.exitTempAnimation()
        isAvailable = false
        plantBuyCoolDown = false
    }

    method newInstance() = createNewInstance.apply()

    var property currentBehaviour = {=>self.defaultTickBehavior()}
    method defaultTickBehavior(){
        isAvailable = sunCounter.canPay( price ) 
        if(isAvailable){
            self.imageProviderSetUse("#Available")
        }else{
            self.imageProviderSetUse("#Unavailable")
        }
    }

    method deselected() { self.currentBehaviour({=>self.defaultTickBehavior()}) }
    method selected() { 
        self.imageProviderSetUse("#Selected")
        self.currentBehaviour({=>})
    }
    override method tick(){ self.currentBehaviour().apply() }

    override method beClicked(){
        if(plantBuyCoolDown){return}
        if(not isAvailable){return}
        player.selectCard(self)
        return
    }

    method use(pos){
        self.startCoolDown()
        sunCounter.spendSuns(price)
        self.newInstance().start(pos)
    }

    method startCoolDown(){
        plantBuyCoolDown true
        self.animationCallback({ => plantBuyCoolDown = false })
        self.imageHandler().useTempAnimation(imageProviderSet.get("#CoolDown"), 1)
    }
}

object sunFlowerCard inherits PlantCard(
    price = 50,
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(key = "#Available", value = new Sprite( image = "sprites/cards/sunFlower/available.png")),
            new ImageProviderEntry(key = "#Unavailable", value = new Sprite( image = "sprites/cards/sunFlower/unavailable.png")),
            new ImageProviderEntry(key = "#Selected", value = new Sprite( image = "sprites/cards/sunFlower/selected.png")),
            new ImageProviderEntry(key = "#CoolDown", value = new Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/sunflower/coolDown"))
        ]),
    createNewInstance = { => new Girasol() }
){}

object peashooterCard inherits PlantCard(
    price = 100,
    imageProviderSet =
        new ImageProviderSet().initialize([
            new ImageProviderEntry(key = "#Available", value = new Sprite( image = "sprites/cards/peashooter/available.png")),
            new ImageProviderEntry(key = "#Unavailable", value = new Sprite( image = "sprites/cards/peashooter/unavailable.png")),
            new ImageProviderEntry(key = "#Selected", value = new Sprite( image = "sprites/cards/peashooter/selected.png")),
            new ImageProviderEntry(key = "#CoolDown", value = new Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/peashooter/coolDown"))
        ]),
    createNewInstance = { => new LanzaGuisantes()}
){}

object wallNutCard inherits PlantCard(
    price = 50,
    imageProviderSet =
        new ImageProviderSet().initialize([
            new ImageProviderEntry(key = "#Available", value = new Sprite( image = "sprites/cards/wallNut/available.png")),
            new ImageProviderEntry(key = "#Unavailable", value = new Sprite( image = "sprites/cards/wallNut/unavailable.png")),
            new ImageProviderEntry(key = "#Selected", value = new Sprite( image = "sprites/cards/wallNut/selected.png")),
            new ImageProviderEntry(key = "#CoolDown", value = new Animation(framesInAnimation = 15, durationInSeconds = 30, animationDirectory = "cards/wallNut/coolDown"))  
        ]),
    createNewInstance = { => new Nuez()}
){}

object snowPeaCard inherits PlantCard(
    price = 175,
    imageProviderSet =
        new ImageProviderSet().initialize([
            new ImageProviderEntry(key = "#Available", value = new Sprite( image = "sprites/cards/snowPea/available.png")),
            new ImageProviderEntry(key = "#Unavailable", value = new Sprite( image = "sprites/cards/snowPea/unavailable.png")),
            new ImageProviderEntry(key = "#Selected", value = new Sprite( image = "sprites/cards/snowPea/selected.png")),
            new ImageProviderEntry(key = "#CoolDown", value = new Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/snowPea/coolDown"))  
        ]),
    createNewInstance = { => new SnowPea()}
){}
