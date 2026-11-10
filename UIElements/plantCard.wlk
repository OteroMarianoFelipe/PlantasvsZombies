import entity.*
import player.player
import plantas.lanzaguisantes.*
import plantas.girasol.Girasol
import plantas.nuez.Nuez
import plantas.snowPea.SnowPea
import entityManager.*
import UIElements.sunCounter.sunCounter
import imageProvider.*

class PlantCard inherits Ticks and Collides and Entity(team = "NEUTRAL", defaultImageProvider =  self.cardUnavailableSprite()){
    const property price
    const property createNewInstance
    const property cardAvailableSprite
    const property cardUnavailableSprite
    const property cardSelectedSprite
    const property cardCoolDownAnimation

    var property isAvailable = false
    var property plantBuyCoolDown = false

    method newInstance() = createNewInstance.apply()

    var property currentBehaviour = {=>self.defaultTickBehavior()}
    method defaultTickBehavior(){
        self.isAvailable( sunCounter.canPay( price ) )
        if(isAvailable){
            self.defaultImageProvider(self.cardAvailableSprite())
        }else{
            self.defaultImageProvider(self.cardUnavailableSprite())
        }
        if(not plantBuyCoolDown){
            self.useDefaultImageProvider()
        }
    }

    method deselected() { self.currentBehaviour({=>self.defaultTickBehavior()}) }
    method selected() { 
        self.imageProvider(self.cardSelectedSprite()) 
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
        self.plantBuyCoolDown(true)
        self.animationCallback({ => self.plantBuyCoolDown(false) })
        self.imageHandler().useTempAnimation(self.cardCoolDownAnimation(), 1)
    }
}

object sunFlowerCard inherits PlantCard(
    price = 50,
    cardAvailableSprite = new Sprite( image = "sprites/cards/sunFlower/available.png"),
    cardUnavailableSprite = new Sprite( image = "sprites/cards/sunFlower/unavailable.png"),
    cardSelectedSprite = new Sprite( image = "sprites/cards/sunFlower/selected.png"),
    cardCoolDownAnimation = new Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/sunflower/coolDown"),
    createNewInstance = { => new Girasol() }
){}

object peashooterCard inherits PlantCard(
    price = 100,
    cardAvailableSprite = new Sprite( image = "sprites/cards/peashooter/available.png"),
    cardUnavailableSprite = new Sprite( image = "sprites/cards/peashooter/unavailable.png"),
    cardSelectedSprite = new Sprite( image = "sprites/cards/peashooter/selected.png"),
    cardCoolDownAnimation = new Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/peashooter/coolDown"),
    createNewInstance = { => new LanzaGuisantes()}
){}

object wallNutCard inherits PlantCard(
    price = 50,
    cardAvailableSprite = new Sprite( image = "sprites/cards/wallNut/available.png"),
    cardUnavailableSprite = new Sprite( image = "sprites/cards/wallNut/unavailable.png"),
    cardSelectedSprite = new Sprite( image = "sprites/cards/wallNut/selected.png"),
    cardCoolDownAnimation = new Animation(framesInAnimation = 15, durationInSeconds = 30, animationDirectory = "cards/wallNut/coolDown"),
    createNewInstance = { => new Nuez()}
){}

object snowPeaCard inherits PlantCard(
    price = 175,
    cardAvailableSprite = new Sprite( image = "sprites/cards/snowPea/available.png"),
    cardUnavailableSprite = new Sprite( image = "sprites/cards/snowPea/unavailable.png"),
    cardSelectedSprite = new Sprite( image = "sprites/cards/snowPea/selected.png"),
    cardCoolDownAnimation = new Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/snowPea/coolDown"),
    createNewInstance = { => new SnowPea()}
){}
