import animation.Animation

object wallNutIdle inherits Animation(
    loop = true,
    durationInSeconds = 0.5,
    framesInAnimation = 4,
    animationDirectory = "plants/wallNut/idle"
){}

object wallNutHurtIdle inherits Animation(
    loop = true,
    durationInSeconds = 0.5,
    framesInAnimation = 4,
    animationDirectory = "plants/wallNut/hurt"
){}

object wallNutDyingIdle inherits Animation(
    loop = true,
    durationInSeconds = 0.5,
    framesInAnimation = 4,
    animationDirectory = "plants/wallNut/dying"
){}