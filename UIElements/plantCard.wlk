import entity.*
import assets.cards.*
import player.player
import plantas.lanzaguisantes.*
import plantas.girasol.Girasol
import plantas.nuez.Nuez
import plantas.snowPea.SnowPea
import entityManager.*
import UIElements.sunCounter.sunCounter

class PlantCard inherits Collides and Ticks and Entity(team = "NEUTRAL", defaultImageProvider =  self.cardUnavailableSprite()){
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
        self.imageProvider(self.cardCoolDownAnimation())
    }
    override method endNonLoopingAnimation(){
        self.plantBuyCoolDown(false)
        super()
    }
}

object sunFlowerCard inherits PlantCard(
    price = 50,
    cardSelectedSprite = new SunFlowerCardSelected(),
    cardAvailableSprite = new SunFlowerCardAvailable(),
    cardUnavailableSprite = new SunFlowerCardUnavailable(),
    cardCoolDownAnimation = new SunFlowerCardCoolDown(),
    createNewInstance = { => new Girasol() }
){}

object peashooterCard inherits PlantCard(
    price = 100,
    cardSelectedSprite = new PeashooterCardSelected(),
    cardAvailableSprite = new PeashooterCardAvailable(),
    cardUnavailableSprite = new PeashooterCardUnavailable(),
    cardCoolDownAnimation = new PeashooterCardCoolDown(),
    createNewInstance = { => new LanzaGuisantes()}
){}

object wallNutCard inherits PlantCard(
    price = 50,
    cardSelectedSprite = new WallNutCardSelected(),
    cardAvailableSprite = new WallNutCardAvailable(),
    cardUnavailableSprite = new WallNutCardUnavailable(),
    cardCoolDownAnimation = new WallNutCardCoolDown(),
    createNewInstance = { => new Nuez()}
){}

object snowPeaCard inherits PlantCard(
    price = 175,
    cardSelectedSprite = new SnowPeaCardSelected(),
    cardAvailableSprite = new SnowPeaCardAvailable(),
    cardUnavailableSprite = new SnowPeaCardUnavailable(),
    cardCoolDownAnimation = new SnowPeaCardCoolDown(),
    createNewInstance = { => new SnowPea()}
){}