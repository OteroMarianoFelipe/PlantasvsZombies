import behavior.*

class ActionModule{
    const behaviors // = #{}
    var forceStopped = false
    
    method stop() { forceStopped = true }
    method resume(){ forceStopped = false }

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
        const proposedProviders = behaviors.map({ behavior =>
            behavior.getImageProvider(user)
        }).filter({ p => p != null })
        return proposedProviders.findOrDefault({ p => true}, null)
    }

    method slowDown(factor){
        behaviors.forEach({ b => b.slowDown(factor) })
    }
    method restoreSpeed(){
        behaviors.forEach({ b => b.restoreSpeed() })
    }
}