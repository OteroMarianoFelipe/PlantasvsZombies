import animation.*

class PeaShooterIdle inherits Animation(
    loop = true,
    durationInSeconds = 0.5,
    framesInAnimation = 8,
    animationDirectory = "plants/peashooter/idle"
){}

class PeaShooterAction inherits Animation(
    loop = false,
    durationInSeconds = 0.25,
    framesInAnimation = 4,
    animationDirectory = "plants/peashooter/active"
){}

class PeaShot inherits StaticAnimation( image = "sprites/projectiles/pea.png" ){}

class PeaShotImpact inherits Animation(
    loop = false,
    durationInSeconds = 0.1,
    framesInAnimation = 4,
    animationDirectory = "projectiles/pea/impact"
){}