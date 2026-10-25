import imageProvider.Animation

class ZombieBehaviorAnimation inherits Animation(loop = true, durationInSeconds = 0.95, framesInAnimation = 7){}

class ZombieWalkingFH inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/walkingFH"){}
class ZombieWalkingHurt inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/walkingHurt"){}
class ZombieWalkingDying inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/walkingDying"){}
class ZombieEatingFH inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/eatingFH"){}
class ZombieEatingHurt inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/eatingHurt"){}
class ZombieEatingDying inherits ZombieBehaviorAnimation(animationDirectory = "zombies/basic/eatingDying"){}

class ConeHeadWalkingFH inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/walkingFH"){}
class ConeHeadWalkingHurt inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/walkingHurt"){}
class ConeHeadWalkingDying inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/walkingDying"){}
class ConeHeadEatingFH inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/eatingFH"){}
class ConeHeadEatingHurt inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/eatingHurt"){}
class ConeHeadEatingDying inherits ZombieBehaviorAnimation(animationDirectory = "zombies/coneHead/eatingDying"){}

class ZombieDeath inherits Animation(
    loop = false,
    durationInSeconds = 1,
    framesInAnimation = 9,
    animationDirectory = "zombies/basic/death"
){}