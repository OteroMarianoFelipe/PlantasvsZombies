import animation.Animation
import animation.StaticAnimation

class CardCoolDownAnimation inherits Animation(
    loop = false,
    framesInAnimation = 15
){}

class SunFlowerCardAvailable inherits StaticAnimation( image = "sprites/cards/sunFlower/available.png"){}

class SunFlowerCardUnavailable inherits StaticAnimation( image = "sprites/cards/sunFlower/unavailable.png"){}

class SunFlowerCardSelected inherits StaticAnimation( image = "sprites/cards/sunFlower/selected.png"){}

class SunFlowerCardCoolDown inherits CardCoolDownAnimation(
    durationInSeconds = 7.5,
    animationDirectory = "cards/sunflower/coolDown"
){}

class WallNutCardAvailable inherits StaticAnimation( image = "sprites/cards/wallNut/available.png"){}
class WallNutCardUnavailable inherits StaticAnimation( image = "sprites/cards/wallNut/unavailable.png"){}
class WallNutCardSelected inherits StaticAnimation( image = "sprites/cards/wallNut/selected.png"){}

class WallNutCardCoolDown inherits CardCoolDownAnimation(
    durationInSeconds = 30,
    animationDirectory = "cards/wallNut/coolDown"
){}

class PeashooterCardAvailable inherits StaticAnimation( image = "sprites/cards/peashooter/available.png"){}
class PeashooterCardUnavailable inherits StaticAnimation( image = "sprites/cards/peashooter/unavailable.png"){}
class PeashooterCardSelected inherits StaticAnimation( image = "sprites/cards/peashooter/selected.png"){}

class PeashooterCardCoolDown inherits CardCoolDownAnimation(
    durationInSeconds = 7.5,
    animationDirectory = "cards/peashooter/coolDown"
){}

class SnowPeaCardAvailable inherits StaticAnimation( image = "sprites/cards/snowPea/available.png"){}
class SnowPeaCardUnavailable inherits StaticAnimation( image = "sprites/cards/snowPea/unavailable.png"){}
class SnowPeaCardSelected inherits StaticAnimation( image = "sprites/cards/snowPea/selected.png"){}

class SnowPeaCardCoolDown inherits CardCoolDownAnimation(
    durationInSeconds = 7.5,
    animationDirectory = "cards/snowPea/coolDown"
){}