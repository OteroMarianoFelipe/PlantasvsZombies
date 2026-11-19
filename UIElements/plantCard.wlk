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

    var property state = available
    method state(newState){ 
        state = newState
        state.start(self) 
    }

    method reset(){
        imageHandler.exitTempAnimation()
        self.state(unavailable)
    }

    method newInstance() = createNewInstance.apply()

    method deselected() { self.state().deselected(self) }
    method selected() { self.state(selected) }

    override method tick(){ state.tick(self) }
    override method beClicked(){ state.beClicked(self) }

    method use(pos){
        self.state(onCoolDown)
        sunCounter.spendSuns(price)
        self.newInstance().start(pos)
    }
}

class CardState{
    method start(card){ self.tick(card) }
    method tick(card){}
    method beClicked(card){}
}
object unavailable inherits CardState{
    override method tick(card){
        if(sunCounter.canPay( card.price() )){
            card.state(available)
        }else{
            card.imageProviderSetUse("#Unavailable")
        }
    }
}
object available inherits CardState{
    override method tick(card){
        if(not sunCounter.canPay( card.price() )){
            card.state(unavailable)
        }else{
            card.imageProviderSetUse("#Available")
        }
    }
    override method beClicked(card){ card.selected() }
}
object selected inherits CardState{
    override method start(card){
        super(card)
        player.selectCard(card)
        card.imageProviderSetUse("#Selected")
    }
    method deselected(card){
        card.state(unavailable)
    }
}
object onCoolDown inherits CardState{
    override method start(card){
        super(card)
        card.animationCallback({ => card.state(unavailable) })
        card.imageHandler().useTempAnimation(card.imageProviderSet().get("#CoolDown"), 1)
    }
    method deselected(card){}
}

object sunFlowerCard inherits PlantCard(
    price = 50,
    imageProviderSet = 
        new ImageProviderSet().initialize([
            new ImageProviderEntry(key = "#Available",   value = sunFlowerCardAvailable ),
            new ImageProviderEntry(key = "#Unavailable", value = sunFlowerCardUnavailable ),
            new ImageProviderEntry(key = "#Selected",    value = sunFlowerCardSelected ),
            new ImageProviderEntry(key = "#CoolDown",    value = sunFlowerCardCooldown )
        ]),
    createNewInstance = { => new Girasol() }
){}

object peashooterCard inherits PlantCard(
    price = 100,
    imageProviderSet =
        new ImageProviderSet().initialize([
            new ImageProviderEntry(key = "#Available",   value = peashooterCardAvailable ),
            new ImageProviderEntry(key = "#Unavailable", value = peashooterCardUnavailable ),
            new ImageProviderEntry(key = "#Selected",    value = peashooterCardSelected ),
            new ImageProviderEntry(key = "#CoolDown",    value = peashooterCardCooldown )
        ]),
    createNewInstance = { => new LanzaGuisantes()}
){}

object wallNutCard inherits PlantCard(
    price = 50,
    imageProviderSet =
        new ImageProviderSet().initialize([
            new ImageProviderEntry(key = "#Available",   value = wallNutCardAvailable ),
            new ImageProviderEntry(key = "#Unavailable", value = wallNutCardUnavailable ),
            new ImageProviderEntry(key = "#Selected",    value = wallNutCardSelected ),
            new ImageProviderEntry(key = "#CoolDown",    value = wallNutCardCooldown )
        ]),
    createNewInstance = { => new Nuez()}
){}

object snowPeaCard inherits PlantCard(
    price = 175,
    imageProviderSet =
        new ImageProviderSet().initialize([
            new ImageProviderEntry(key = "#Available",   value = snowPeaCardAvailable ),
            new ImageProviderEntry(key = "#Unavailable", value = snowPeaCardUnavailable ),
            new ImageProviderEntry(key = "#Selected",    value = snowPeaCardSelected ),
            new ImageProviderEntry(key = "#CoolDown",    value = snowPeaCardCooldown ) 
        ]),
    createNewInstance = { => new SnowPea()}
){}

object sunFlowerCardAvailable inherits Sprite( image = "sprites/cards/sunFlower/available.png"){}
object sunFlowerCardUnavailable inherits Sprite( image = "sprites/cards/sunFlower/unavailable.png"){}
object sunFlowerCardSelected inherits Sprite( image = "sprites/cards/sunFlower/selected.png"){}
object sunFlowerCardCooldown inherits Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/sunflower/coolDown"){}

object peashooterCardAvailable   inherits Sprite( image = "sprites/cards/peashooter/available.png"){}
object peashooterCardUnavailable inherits Sprite( image = "sprites/cards/peashooter/unavailable.png"){}
object peashooterCardSelected    inherits Sprite( image = "sprites/cards/peashooter/selected.png"){}
object peashooterCardCooldown    inherits Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/peashooter/coolDown"){}

object wallNutCardAvailable inherits Sprite( image = "sprites/cards/wallNut/available.png"){}
object wallNutCardUnavailable inherits Sprite( image = "sprites/cards/wallNut/unavailable.png"){}
object wallNutCardSelected inherits Sprite( image = "sprites/cards/wallNut/selected.png"){}
object wallNutCardCooldown inherits Animation(framesInAnimation = 15, durationInSeconds = 30, animationDirectory = "cards/wallNut/coolDown"){}

object snowPeaCardAvailable inherits Sprite( image = "sprites/cards/snowPea/available.png"){}
object snowPeaCardUnavailable inherits Sprite( image = "sprites/cards/snowPea/unavailable.png"){}
object snowPeaCardSelected inherits Sprite( image = "sprites/cards/snowPea/selected.png"){}
object snowPeaCardCooldown inherits Animation(framesInAnimation = 15, durationInSeconds = 7.5, animationDirectory = "cards/snowPea/coolDown"){}