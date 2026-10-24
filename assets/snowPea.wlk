import animation.*

class SnowPeaIdle inherits Animation(
    loop = true,
    durationInSeconds = 0.5,
    framesInAnimation = 8,
    animationDirectory = "plants/snowPea/idle"
){}

class SnowPeaAction inherits Animation(
    loop = false,
    durationInSeconds = 0.25,
    framesInAnimation = 4,
    animationDirectory = "plants/snowPea/active"
){}

class FrozenPea inherits StaticAnimation( image = "sprites/projectiles/frozenPea.png" ){}

class FrozenPeaImpact inherits Animation(
    loop = false,
    durationInSeconds = 0.15,
    framesInAnimation = 6,
    animationDirectory = "projectiles/frozenPea/impact"
){}