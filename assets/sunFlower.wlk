import animation.Animation
import animation.StaticAnimation

object sunFlowerIdle inherits Animation(
    loop = true,
    durationInSeconds = 0.6,
    framesInAnimation = 9,
    animationDirectory = "plants/sunFlower/idle"
){}

object sunFlowerActive inherits Animation(
    loop = false,
    durationInSeconds = 0.6,
    framesInAnimation = 9,
    animationDirectory = "plants/sunFlower/active"
){}

object bigSun inherits Animation(
    loop = true,
    durationInSeconds = 0.4,
    framesInAnimation = 2,
    animationDirectory = "projectiles/sun/big"
){}

object smallSun inherits Animation(
    loop = true,
    durationInSeconds = 0.4,
    framesInAnimation = 2,
    animationDirectory = "projectiles/sun/small"
){}