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

    method slowDown(factor){
        behaviors.forEach({ b => b.slowDown(factor) })
    }
    method restoreSpeed(){
        behaviors.forEach({ b => b.restoreSpeed() })
    }
}