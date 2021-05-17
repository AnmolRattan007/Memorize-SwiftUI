//
//  SwiftFile.swift
//  Memorize
//
//  Created by anmol rattan on 21/04/21.
//

import Foundation


struct MemoryGame<CardContent:Equatable>{
    
    var cards:[Card]
    var indexOfOneAndOnlyOneFaceUpCard:Int?{
        get
        {return  cards.indices.filter{cards[$0].isFaceUp}.only}
        set{
            for index in cards.indices{
                cards[index].isFaceUp = newValue == index
            }
        }
    }
    
    var score = 0
    
    init(numberOfCards:Int,cardContentFactory:(Int)->CardContent){
        cards = [Card]()
        for pairOfCards in 0..<numberOfCards{
            cards.append(Card(emoji: cardContentFactory(pairOfCards), id: pairOfCards*2))
            cards.append(Card(emoji: cardContentFactory(pairOfCards), id: pairOfCards*2+1))
        }
        cards.shuffle()
    }
    
    
    mutating func chooseCard(_ card:Card){
        print("Chosen card \(card)")
        let chosenIndex = cards.matched(with: card)
        if let chosenIndex = chosenIndex, !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
            
            if let potentialMatchIndex = indexOfOneAndOnlyOneFaceUpCard{
                if cards[chosenIndex].emoji == cards[potentialMatchIndex].emoji{
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                }else{
                    score -= 1
                }
                
                self.cards[chosenIndex].isFaceUp = true
            }else{
                indexOfOneAndOnlyOneFaceUpCard = chosenIndex
            }
            
            cards[chosenIndex].isFaceUp = true
        }
        
        
    }
    
   
    
    
    struct Card:Identifiable{
        var isFaceUp:Bool = false{
            didSet{
                if isFaceUp{
                    startUsingBonusTime()
                }else{
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched:Bool = false{
            didSet{
                stopUsingBonusTime()
            }
        }
        var emoji:CardContent
        var id:Int
        
        
        var bonusTimeLimit:TimeInterval = 6
        var lastFaceUpDate:Date?
        var pastFaceUpTime:TimeInterval = 0
        private var faceUpTime:TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }
        
        var bonusTimeRemaning :TimeInterval{
            max(0,bonusTimeLimit-faceUpTime)
        }
        
        var bonusRemaning:TimeInterval{
            (bonusTimeLimit>0 && bonusTimeRemaning>0) ? bonusTimeRemaning/bonusTimeLimit : 0
        }
        
        
        var hasEarnedBonus:Bool{
            isMatched && bonusTimeRemaning>0
        }
        
        var isConsumingBonusTime:Bool{
            isFaceUp && !isMatched && bonusTimeRemaning>0
        }
        
        private mutating func startUsingBonusTime(){
            if isConsumingBonusTime,lastFaceUpDate==nil{
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
    
}

