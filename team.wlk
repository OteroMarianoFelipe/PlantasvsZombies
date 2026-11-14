class Team{
    const rival = null
    method isEnemy(other) = other.team() == rival
}

object plantsTeam inherits Team(rival = zombiesTeam){}

object zombiesTeam inherits Team(rival = plantsTeam){}

object neutralTeam inherits Team(){
    override method isEnemy(other) = false
}