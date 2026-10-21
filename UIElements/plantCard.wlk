import entity.*
import assets.cards.*
import player.player
import plantas.lanzaguisantes.*
import plantas.girasol.Girasol
import plantas.nuez.Nuez
import plantas.snowPea.SnowPea
import entityManager.*
import UIElements.sunCounter.sunCounter

class PlantCard inherits Entity{
    override method team() = "NEUTRAL"
    var property isAvailable = false
    var property plantBuyCoolDown = false

    const property price
    method plantToCreate()

    override method defaultAnimation() = self.cardAvailableSprite()
    method cardAvailableSprite()
    method cardUnavailableSprite()
    method cardSelectedSprite()
    method cardCoolDownAnimation()

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
        entityManager.addEntity(self.plantToCreate(), pos)
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

object sunFlowerCard inherits PlantCard(price = 50){
    override method plantToCreate() = new Girasol()
    override method cardSelectedSprite() = sunFlowerCardSelected
    override method cardAvailableSprite() = sunFlowerCardAvailable
    override method cardUnavailableSprite() = sunFlowerCardUnavailable
    override method cardCoolDownAnimation() = sunFlowerCardCoolDown
}

object peashooterCard inherits PlantCard(price = 100){
    override method plantToCreate() = new LanzaGuisantes()
    override method cardSelectedSprite() = peashooterCardSelected
    override method cardAvailableSprite() = peashooterCardAvailable
    override method cardUnavailableSprite() = peashooterCardUnavailable
    override method cardCoolDownAnimation() = peashooterCardCoolDown
}

object wallNutCard inherits PlantCard(price = 50){
    override method plantToCreate() = new Nuez()
    override method cardSelectedSprite() = wallNutCardSelected
    override method cardAvailableSprite() = wallNutCardAvailable
    override method cardUnavailableSprite() = wallNutCardUnavailable
    override method cardCoolDownAnimation() = wallNutCardCoolDown
}

object snowPeaCard inherits PlantCard(price = 175){
    override method plantToCreate() = new SnowPea()
    override method cardSelectedSprite() = snowPeaCardSelected
    override method cardAvailableSprite() = snowPeaCardAvailable
    override method cardUnavailableSprite() = snowPeaCardUnavailable
    override method cardCoolDownAnimation() = snowPeaCardCoolDown
}