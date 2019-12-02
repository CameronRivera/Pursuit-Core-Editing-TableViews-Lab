//
//  GroceryItem.swift
//  EditingTableViews
//
//  Created by Cameron Rivera on 11/20/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import Foundation

enum Status: String, CaseIterable{
    case purchased
    case unpurchased
}

class GroceryItem{
    var name: String = ""
    var price: Double = 0.0
    var status: Status = .purchased
    
    func toggleStatus(){
        if self.status == .purchased{
            self.status = .unpurchased
        } else if self.status == .unpurchased{
            self.status = .purchased
        }
    }
    
    static func makeMeAMatrix(outOf arr: [GroceryItem]) -> [[GroceryItem]]{
        let sortedArr = arr.sorted { $0.status.rawValue < $1.status.rawValue }
        let numberOfSections = Set<Status>(sortedArr.map{ $0.status })
        print("The number of sections in the matrix is \(numberOfSections.count)")
        var theMatrix = Array(repeating: [GroceryItem](), count: numberOfSections.count)
        
        var currentIndex = 0
        var currentSection = sortedArr.first?.status
        
        for element in sortedArr {
            if element.status == currentSection{
                theMatrix[currentIndex].append(element)
            } else {
                currentIndex += 1
                currentSection = element.status
                theMatrix[currentIndex].append(element)
            }
        }
        return theMatrix
    }
}
