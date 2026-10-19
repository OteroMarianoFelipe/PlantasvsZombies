import animation.Animation
import animation.StaticAnimation

object sunFlowerIdle inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.6
    override method framesInAnimation() = 9
    override method animationDirectory() = "plants/sunFlower/idle"
}

object sunFlowerActive inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 0.6
    override method framesInAnimation() = 9
    override method animationDirectory() = "plants/sunFlower/active"
}

object bigSun inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.4
    override method framesInAnimation() = 2
    override method animationDirectory() = "projectiles/sun/big"
}

object smallSun inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.4
    override method framesInAnimation() = 2
    override method animationDirectory() = "projectiles/sun/small"
}