import animation.*

object snowPeaIdle inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.5
    override method framesInAnimation() = 8
    override method animationDirectory() = "plants/snowPea/idle"
}

object snowPeaAction inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 0.4
    override method framesInAnimation() = 4
    override method animationDirectory() = "plants/snowPea/active"
}

object frozenPea inherits StaticAnimation( img = "sprites/projectiles/frozenPea.png" ){}

object frozenPeaImpact inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 0.15
    override method framesInAnimation() = 6
    override method animationDirectory() = "projectiles/frozenPea/impact"
}