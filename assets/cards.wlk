import animation.Animation
import animation.StaticAnimation

object sunFlowerCardAvailable inherits StaticAnimation( img = "sprites/cards/sunFlower/available.png"){}

object sunFlowerCardUnavailable inherits StaticAnimation( img = "sprites/cards/sunFlower/unavailable.png"){}

object sunFlowerCardSelected inherits StaticAnimation( img = "sprites/cards/sunFlower/selected.png"){}

object sunFlowerCardCoolDown inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 7.5
    override method framesInAnimation() = 15
    override method animationDirectory() = "cards/sunflower/coolDown"
}

object wallNutCardAvailable inherits StaticAnimation( img = "sprites/cards/wallNut/available.png"){}
object wallNutCardUnavailable inherits StaticAnimation( img = "sprites/cards/wallNut/unavailable.png"){}
object wallNutCardSelected inherits StaticAnimation( img = "sprites/cards/wallNut/selected.png"){}

object wallNutCardCoolDown inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 30
    override method framesInAnimation() = 15
    override method animationDirectory() = "cards/wallNut/coolDown"
}

object peashooterCardAvailable inherits StaticAnimation( img = "sprites/cards/peashooter/available.png"){}
object peashooterCardUnavailable inherits StaticAnimation( img = "sprites/cards/peashooter/unavailable.png"){}
object peashooterCardSelected inherits StaticAnimation( img = "sprites/cards/peashooter/selected.png"){}

object peashooterCardCoolDown inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 7.5
    override method framesInAnimation() = 15
    override method animationDirectory() = "cards/peashooter/coolDown"
}

object snowPeaCardAvailable inherits StaticAnimation( img = "sprites/cards/snowPea/available.png"){}
object snowPeaCardUnavailable inherits StaticAnimation( img = "sprites/cards/snowPea/unavailable.png"){}
object snowPeaCardSelected inherits StaticAnimation( img = "sprites/cards/snowPea/selected.png"){}

object snowPeaCardCoolDown inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 7.5
    override method framesInAnimation() = 15
    override method animationDirectory() = "cards/snowPea/coolDown"
}