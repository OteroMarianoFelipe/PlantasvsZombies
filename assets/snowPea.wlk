import animation.*

object snowPeaIdle inherits Animation(
    loop = true,
    durationInSeconds = 0.5,
    framesInAnimation = 8,
    animationDirectory = "plants/snowPea/idle"
){}

object snowPeaAction inherits Animation(
    loop = false,
    durationInSeconds = 0.4,
    framesInAnimation = 4,
    animationDirectory = "plants/snowPea/active"
){}

object frozenPea inherits StaticAnimation( img = "sprites/projectiles/frozenPea.png" ){}

object frozenPeaImpact inherits Animation(
    loop = false,
    durationInSeconds = 0.15,
    framesInAnimation = 6,
    animationDirectory = "projectiles/frozenPea/impact"
){}