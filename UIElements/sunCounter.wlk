import animation.*
import entity.*
import UIElements.UIElement.*

object sunCounter inherits UIElement{
    var property suns =200

    method canPay(cost) = suns >= cost
    method addSuns(amount) {
        suns += amount 
        self.updateCount()
    }
    method spendSuns(amount) { 
        suns -= amount 
        self.updateCount()
    }

    override method tick(){}

    method hundreds() = (suns/100).truncate(0)
    method tens() = suns - self.hundreds()*100

    method updateCount(){
        sunCounterIcoWithHundreds.changeHundreds(self.hundreds())
        sunCounterTens.changeTens(self.tens())
    }

    method start(){
        game.addVisual(sunCounterIcoWithHundreds)
        game.addVisual(sunCounterTens)
        self.updateCount()
    }

}

object sunCounterIcoWithHundreds inherits StaticAnimation( image = "sprites/sunCounter/iconWithHundreds/"){
    const property position = game.at(0,0)
    var property hundreds = 0
    method changeHundreds(newNumber){
        if(newNumber!=hundreds and newNumber.between(0,9)){
            self.hundreds(newNumber)
        }
    }
    override method image() = image + hundreds + ".png"
}

object sunCounterTens inherits StaticAnimation( image = "sprites/sunCounter/tens/"){
    const property position = game.at(1,0)
    var property tens = 0
    method numberHasSprite(num) = [0, 25, 50, 75].contains(num)
    method changeTens(newNumber){
        if(newNumber != tens and self.numberHasSprite(newNumber)){
            self.tens(newNumber)
        }
    }
    override method image() = image + tens + ".png"
}