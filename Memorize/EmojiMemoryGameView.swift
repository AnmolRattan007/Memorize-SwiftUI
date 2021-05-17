//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by anmol rattan on 19/04/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel:EmojiMemoryGame
    @State var scale:Double = 1
    var body: some View {
        ZStack{
            
           
            VStack{
                Grid(items: viewModel.cards){ card in
                    CardView(card: card)
                        .onTapGesture{
                        withAnimation(.linear(duration:1)){
                        self.viewModel.chooseCard(card: card)
                        }
                    }
                    .padding(5)
                        .onAppear{
                            withAnimation(Animation.easeInOut(duration: 2)){
                                scale = 0.5
                            }
                        }
                }
                
                .padding()
               
                .foregroundColor(.orange)
               
                Button("New Game"){
                    withAnimation(Animation.easeInOut(duration: 2)){
                    viewModel.reloadGame()
                    }
                }
                Spacer()
                Text("Score = \(viewModel.score)")
            }
            
            
            
        }
        
        
    }
}

struct CardView:View{
    var card:MemoryGame<String>.Card
    var body: some View{
        
        GeometryReader{ geometry in
            self.body(for: geometry.size)
        }
        
    }
    @State private var animatedBonusRemaning:Double = 0
    
    private func startBonusTimeAnimation(){
        animatedBonusRemaning = card.bonusRemaning
        withAnimation(.linear(duration:card.bonusTimeRemaning)){
            animatedBonusRemaning = 0
        }
    }
    
   @ViewBuilder
    private func body(for size:CGSize)-> some View{
        if card.isFaceUp || !card.isMatched{
        
        ZStack{
            Group{
            if card.isConsumingBonusTime{
            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaning*360-90), clockwise: true)
                .onAppear{
                    self.startBonusTimeAnimation()
                }
            }else{
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaning*360-90), clockwise: true)
            }
            }.padding(5)
            .opacity(0.4)
            Text(card.emoji)
                .font(Font.system(size: fontSize(for: size)))
                .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
                
           
        }
        .cardify(isFaceUp: card.isFaceUp)
        .transition(AnyTransition.scale)
       
        }
    }
    private func fontSize(for size:CGSize)->CGFloat{
        min(size.width, size.height)*0.7
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.chooseCard(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
