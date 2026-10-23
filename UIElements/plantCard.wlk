import entity.*
import assets.cards.*
import player.player
import plantas.lanzaguisantes.*
import plantas.girasol.Girasol
import plantas.nuez.Nuez
import plantas.snowPea.SnowPea
import entityManager.*
import UIElements.sunCounter.sunCounter
import UIElements.UIElement.*

class PlantCard inherits UIElement{
    const property price
    const property createNewInstance
    const property cardAvailableSprite
    const property cardUnavailableSprite
    const property cardSelectedSprite
    const property cardCoolDownAnimation

    var property isAvailable = false
    var property plantBuyCoolDown = false

    override method defaultAnimation() = self.cardAvailableSprite()

    method newInstance() = createNewInstance.apply()

    var property currentBehaviour = {=>self.defaultTickBehavior()}
    method defaultTickBehavior(){
        self.isAvailable( sunCounter.canPay( price ) )
        if(isAvailable){
            self.changeDefaultAnimation(self.cardAvailableSprite())
        }else{
            self.changeDefaultAnimation(self.cardUnavailableSprite())
        }
        if(not plantBuyCoolDown){
            self.useDefaultAnimation()
        }
    }

    method deselected() { self.currentBehaviour({=>self.defaultTickBehavior()}) }
    method selected() { 
        animationHandler.changeAnimation(self.cardSelectedSprite()) 
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
        entityManager.addEntity(self.newInstance(), pos)
    }

    method startCoolDown(){
        self.plantBuyCoolDown(true)
        animationHandler.changeAnimation(self.cardCoolDownAnimation())
    }
    override method endNonLoopingAnimation(){
        self.plantBuyCoolDown(false)
        super()
    }
}

object sunFlowerCard inherits PlantCard(
    price = 50,
    cardSelectedSprite = sunFlowerCardSelected,
    cardAvailableSprite = sunFlowerCardAvailable,
    cardUnavailableSprite = sunFlowerCardUnavailable,
    cardCoolDownAnimation = sunFlowerCardCoolDown,
    createNewInstance = { => new Girasol() }
){}

object peashooterCard inherits PlantCard(
    price = 100,
    cardSelectedSprite = peashooterCardSelected,
    cardAvailableSprite = peashooterCardAvailable,
    cardUnavailableSprite = peashooterCardUnavailable,
    cardCoolDownAnimation = peashooterCardCoolDown,
    createNewInstance = { => new LanzaGuisantes()}
){}

object wallNutCard inherits PlantCard(
    price = 50,
    cardSelectedSprite = wallNutCardSelected,
    cardAvailableSprite = wallNutCardAvailable,
    cardUnavailableSprite = wallNutCardUnavailable,
    cardCoolDownAnimation = wallNutCardCoolDown,
    createNewInstance = { => new Nuez()}
){}

object snowPeaCard inherits PlantCard(
    price = 175,
    cardSelectedSprite = snowPeaCardSelected,
    cardAvailableSprite = snowPeaCardAvailable,
    cardUnavailableSprite = snowPeaCardUnavailable,
    cardCoolDownAnimation = snowPeaCardCoolDown,
    createNewInstance = { => new SnowPea()}
){}