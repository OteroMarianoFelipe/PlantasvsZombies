import animation.*

object peaShooterIdle inherits Animation(
    loop = true,
    durationInSeconds = 0.5,
    framesInAnimation = 8,
    animationDirectory = "plants/peashooter/idle"
){}

object peaShooterAction inherits Animation(
    loop = false,
    durationInSeconds = 0.4,
    framesInAnimation = 4,
    animationDirectory = "plants/peashooter/active"
){}

object peaShot inherits StaticAnimation( img = "sprites/projectiles/pea.png" ){}

object peaShotImpact inherits Animation(
    loop = false,
    durationInSeconds = 0.1,
    framesInAnimation = 4,
    animationDirectory = "projectiles/pea/impact"
){}