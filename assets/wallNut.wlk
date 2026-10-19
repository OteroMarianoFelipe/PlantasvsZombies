import animation.Animation

object wallNutIdle inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.5
    override method framesInAnimation() = 4
    override method animationDirectory() = "plants/wallNut/idle"
}

object wallNutHurtIdle inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.5
    override method framesInAnimation() = 4
    override method animationDirectory() = "plants/wallNut/hurtIdle"
}

object wallNutDyingIdle inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.5
    override method framesInAnimation() = 4
    override method animationDirectory() = "plants/wallNut/dyingIdle"
}