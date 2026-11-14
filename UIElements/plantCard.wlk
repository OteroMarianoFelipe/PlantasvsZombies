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

    var property isAvailable = false
    var property plantBuyCoolDown = false

    method newInstance() = createNewInstance.apply()

    var property currentBehaviour = {=>self.defaultTickBehavior()}
    method defaultTickBehavior(){
        self.isAvailable( sunCounter.canPay( price ) )
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
        self.plantBuyCoolDown(true)
        self.animationCallback({ => self.plantBuyCoolDown(false) })
        self.imageHandler().useTempAnimation(imageProviderSet.getProvider("#CoolDown"), 1)
    }
}

object sunFlowerCard inherits PlantCard(
    price = 50,
    imageProviderSet = 
        new ImageProviderSet(
            entries = #{
                new KeyProviderPair(key = "#Available", provider = new Sprite( image = "sprites/cards/sunFlower/available.png")),
                new KeyProviderPair(key = "#Unavailable", provider = new Sprite( image = "sprites/cards/sunFlower/unavailable.png")),
                new KeyProviderPair(key = "#Selected", provider = new Sprite( image = "sprites/cards/sunFlower/selected.png")),
                new KeyProviderPair(key = "#CoolDown", provider = new Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/sunflower/coolDown"))
            }
        ),
    createNewInstance = { => new Girasol() }
){}

object peashooterCard inherits PlantCard(
    price = 100,
    imageProviderSet =
        new ImageProviderSet(
            entries = #{
                new KeyProviderPair(key = "#Available", provider = new Sprite( image = "sprites/cards/peashooter/available.png")),
                new KeyProviderPair(key = "#Unavailable", provider = new Sprite( image = "sprites/cards/peashooter/unavailable.png")),
                new KeyProviderPair(key = "#Selected", provider = new Sprite( image = "sprites/cards/peashooter/selected.png")),
                new KeyProviderPair(key = "#CoolDown", provider = new Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/peashooter/coolDown"))
            }
        ),
    createNewInstance = { => new LanzaGuisantes()}
){}

object wallNutCard inherits PlantCard(
    price = 50,
    imageProviderSet =
        new ImageProviderSet(
            entries = #{
                new KeyProviderPair(key = "#Available", provider = new Sprite( image = "sprites/cards/wallNut/available.png")),
                new KeyProviderPair(key = "#Unavailable", provider = new Sprite( image = "sprites/cards/wallNut/unavailable.png")),
                new KeyProviderPair(key = "#Selected", provider = new Sprite( image = "sprites/cards/wallNut/selected.png")),
                new KeyProviderPair(key = "#CoolDown", provider = new Animation(framesInAnimation = 15, durationInSeconds = 30, animationDirectory = "cards/wallNut/coolDown"))
            }
        ),
    createNewInstance = { => new Nuez()}
){}

object snowPeaCard inherits PlantCard(
    price = 175,
    imageProviderSet =
        new ImageProviderSet(
            entries = #{
                new KeyProviderPair(key = "#Available", provider = new Sprite( image = "sprites/cards/snowPea/available.png")),
                new KeyProviderPair(key = "#Unavailable", provider = new Sprite( image = "sprites/cards/snowPea/unavailable.png")),
                new KeyProviderPair(key = "#Selected", provider = new Sprite( image = "sprites/cards/snowPea/selected.png")),
                new KeyProviderPair(key = "#CoolDown", provider = new Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/snowPea/coolDown"))
            }
        ),
    createNewInstance = { => new SnowPea()}
){}
