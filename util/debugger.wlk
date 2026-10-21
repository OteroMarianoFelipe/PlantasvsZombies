object debugger{
    method throwError(message){
        console.println("\u001B[31m[ERROR] "+message+"\u001b[0m")
    }
    method warning(message){
        console.println("\u001B[33m[WARNING] "+message+"\u001b[0m")
    }
    method info(message){
        console.println("\u001B[36m[INFO] "+message+"\u001b[0m")
    }
}