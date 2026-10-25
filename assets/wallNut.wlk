import imageProvider.Animation

class WallNutAnimation inherits Animation(
    loop = true,
    durationInSeconds = 0.5,
    framesInAnimation = 4
){}

class WallNutIdle inherits WallNutAnimation( animationDirectory = "plants/wallNut/idle" ){}
class WallNutHurtIdle inherits WallNutAnimation( animationDirectory = "plants/wallNut/hurt" ){}
class WallNutDyingIdle inherits WallNutAnimation( animationDirectory = "plants/wallNut/dying" ){}