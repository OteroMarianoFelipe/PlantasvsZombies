import animation.Animation

class ZombieBehaviorAnimation inherits Animation(loop = true, durationInSeconds = 0.95, framesInAnimation = 7){}

object zombieWalkingFH inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/walkingFH"){}
object zombieWalkingHurt inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/walkingHurt"){}
object zombieWalkingDying inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/walkingDying"){}
object zombieEatingFH inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/eatingFH"){}
object zombieEatingHurt inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/eatingHurt"){}
object zombieEatingDying inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/eatingDying"){}

object coneHeadWalkingFH inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/walkingFH"){}
object coneHeadWalkingHurt inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/walkingHurt"){}
object coneHeadWalkingDying inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/walkingDying"){}
object coneHeadEatingFH inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/eatingFH"){}
object coneHeadEatingHurt inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/eatingHurt"){}
object coneHeadEatingDying inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/eatingDying"){}

object zombieDeath inherits Animation(
    loop = false,
    durationInSeconds = 1,
    framesInAnimation = 9,
    animationDirectory = "zombies/basic/death"
){}