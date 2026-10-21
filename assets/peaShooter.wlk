import animation.*

object peaShooterIdle inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.5
    override method framesInAnimation() = 8
    override method animationDirectory() = "plants/peashooter/idle"
}

object peaShooterAction inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 0.4
    override method framesInAnimation() = 4
    override method animationDirectory() = "plants/peashooter/active"
}

object peaShot inherits StaticAnimation( img = "sprites/projectiles/pea.png" ){}

object peaShotImpact inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 0.1
    override method framesInAnimation() = 4
    override method animationDirectory() = "projectiles/pea/impact"
}