import animation.Animation

object zombieWalking inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/basic/walking"
}