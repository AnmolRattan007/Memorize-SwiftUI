//
//  Grid.swift
//  Memorize
//
//  Created by anmol rattan on 24/04/21.
//

import SwiftUI

struct Grid<Item:Identifiable,ItemView:View>: View {
    
    var items:[Item]
    var viewForItem:(Item)->ItemView
    
    init(items:[Item],viewForItem: @escaping(Item)->ItemView){
        self.items = items
        self.viewForItem = viewForItem
    }
    
    
    var body: some View {
        GeometryReader{ geometry in
            self.body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
        
    }
    
    func body(for layout:GridLayout)-> some View{
        ForEach(items){ item in
            self.body(for: item, of: layout)
        }
    }
    
    func body(for item:Item,of layout:GridLayout)->some View{
        let index = items.matched(with: item)
        
       return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index!))
    }
    
}

