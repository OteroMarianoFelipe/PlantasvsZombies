import imageProvider.Animation
import imageProvider.StaticAnimation

class SunFlowerAnimation inherits Animation(
    durationInSeconds = 0.5,
    framesInAnimation = 9
){}

class SunFlowerIdle inherits SunFlowerAnimation(
    loop = true,
    animationDirectory = "plants/sunFlower/idle" 
){}
class SunFlowerActive inherits SunFlowerAnimation( 
    loop = false,
    animationDirectory = "plants/sunFlower/active" 
){}

class SunAnimation inherits Animation(
    loop = true,
    durationInSeconds = 0.4,
    framesInAnimation = 2
){}

class BigSun inherits SunAnimation( animationDirectory = "projectiles/sun/big" ){}
class SmallSun inherits SunAnimation( animationDirectory = "projectiles/sun/small" ){}