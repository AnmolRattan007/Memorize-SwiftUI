//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by anmol rattan on 21/04/21.
//

import SwiftUI


class EmojiMemoryGame:ObservableObject{
    
   @Published private var model:MemoryGame<String> = EmojiMemoryGame.creatMemoryGame()
    
    
    static func creatMemoryGame()->MemoryGame<String>{
        let emojis = [["👻","🎃","🕷","😗","😜"],["🥛","🍊","🍌","🥓","🍎"],["🙁","🤩","🥳","🧐","🥸"],["🩴","🥿","👠","👡","👢"],["🐳","🐋","🦈","🦭","🐠"],["🦍","🦧","🦣","🐘","🦏"]]
        let themeIndex = Int.random(in: 0..<emojis.count)
        print(themeIndex)
        
        return MemoryGame(numberOfCards: Int.random(in: 2...5)){ pairOfIndex in
            emojis[themeIndex][pairOfIndex]
        }
    }
    
    var cards:Array<MemoryGame<String>.Card>{
        model.cards
    }
    var score:Int{
        model.score
    }
    
    func reloadGame(){
        self.model =  EmojiMemoryGame.creatMemoryGame()
    }
   
    
    
    func chooseCard(card:MemoryGame<String>.Card){
        model.chooseCard(card)

    }
    
}
