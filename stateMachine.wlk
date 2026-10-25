class StateMachine{
    var property currentState
    
    method use(user){
        currentState.use(user)
    }

    method forceStateChange(newState){ currentState = newState }
    method evaluateAlternatives(user){ 
        const newState = currentState.evaluatePaths(user) 
        if(newState != currentState){
            currentState = newState
        }
    }
}

class State{
    const property paths

    method availablePaths(user) = paths.filter({ path => path.condition().apply(user) })
    method evaluatePaths(user){
        var stateToChangeTo = self
        const pathsToUse = self.availablePaths(user)
        if( pathsToUse.size() > 0 ){
            const pathToUse = pathsToUse.get(0)
            stateToChangeTo = pathToUse.proposedState()
            pathToUse.transition().apply(self, stateToChangeTo, user)
        }
        return stateToChangeTo
    }   
    method use(user)
}

class Path{
    const property proposedState
    const property condition
    const property transition = { previousState, nextState, user => }
}

class BehavioralState inherits State{
    const property behaviors
    override method use(user){
        behaviors.forEach({ behavior => behavior.use(user) })
    }
}