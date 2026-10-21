import animation.Animation

object zombieWalkingFH inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/basic/walkingFH"
}

object zombieWalkingHurt inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/basic/walkingHurt"
}

object zombieWalkingDying inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/basic/walkingDying"
}

object zombieEatingFH inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/basic/eatingFH"
}

object zombieEatingHurt inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/basic/eatingHurt"
}

object zombieEatingDying inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 5
    override method animationDirectory() = "zombies/basic/eatingDying"
}

object zombieDeath inherits Animation{
    override method loop() = false
    override method durationInSeconds() = 1
    override method framesInAnimation() = 9
    override method animationDirectory() = "zombies/basic/death"
}

object coneHeadWalkingFH inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/coneHead/walkingFH"
}

object coneHeadWalkingHurt inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/coneHead/walkingHurt"
}

object coneHeadWalkingDying inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/coneHead/walkingDying"
}

object coneHeadEatingFH inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/coneHead/eatingFH"
}

object coneHeadEatingHurt inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 7
    override method animationDirectory() = "zombies/coneHead/eatingHurt"
}

object coneHeadEatingDying inherits Animation{
    override method loop() = true
    override method durationInSeconds() = 0.95
    override method framesInAnimation() = 5
    override method animationDirectory() = "zombies/coneHead/eatingDying"
}