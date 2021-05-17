//
//  Extension+Array.swift
//  Memorize
//
//  Created by anmol rattan on 24/04/21.
//

import Foundation


extension Array where Element:Identifiable{
    

    func matched(with element:Element)->Int?{
        for (index,item) in self.enumerated(){
            if element.id == item.id{
                return index
            }
        }
        
        return nil
    }
    
   
}

extension Array{
    var only:Element?{
        return self.count==1 ? self.first : nil
    }
    
}
