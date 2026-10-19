object debugger{
    method throwError(message){
        console.println("\u001B[31m[ERROR] "+message)
    }
    method warning(message){
        console.println("\u001B[33m[WARNING] "+message)
    }
    method info(message){
        console.println("\u001B[36m[INFO] "+message)
    }
}