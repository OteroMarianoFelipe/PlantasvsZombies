import util.debugger.*
import behavior.*

class ActionModule{
    const behaviors // = #{}
    var forceStopped = false
    method forceStopped() = forceStopped

    var providerCandidates = []
    method providerCandidates() = providerCandidates
    
    method stop() { forceStopped = true }
    method resume(){ forceStopped = false }

    method clear(){ behaviors.clear() }

    method hasBehavior(key) = behaviors.findOrDefault({b=>b.key() == key}, null) != null

    method getBehavior(key){
        const behaviorFound = behaviors.findOrDefault({ b =>
            b.key() == key
        }, null)
        return behaviorFound
    }

    method addBehavior(behavior){
        behaviors.add(behavior)
    }

    method removeBehavior(key){
        if(self.hasBehavior(key)){
            behaviors.remove(self.getBehavior(key))
        }
    }

    method modifyBehavior(key, bloqueDeModificaciones){
        bloqueDeModificaciones.apply(self.getBehavior(key))
    }

    method use(user){
        if( not forceStopped ){
            behaviors.forEach({ b =>
                if(forceStopped){return}
                b.tick(user)
                b.tryToUse(user)
            })
        }
    }

    method getImageProvider(user){
        providerCandidates.add(null)
        const returnValue = providerCandidates.head()
        providerCandidates = [].copy()
        return returnValue
    }

    method slowDown(factor){
        behaviors.forEach({ b => b.slowDown(factor) })
    }
    method restoreSpeed(){
        behaviors.forEach({ b => b.restoreSpeed() })
    }
}