//
//  NewGroceryItemViewController.swift
//  EditingTableViews
//
//  Created by Cameron Rivera on 11/20/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import UIKit

class NewGroceryItemViewController: UIViewController {

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    var newItem: GroceryItem = GroceryItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameTextField.delegate = self
        itemPriceTextField.delegate = self
    }
    
    private func areYouANumber(_ inputText: String) -> Bool{
        if inputText.count < 1{
            return false
        }
        let tempText = inputText.components(separatedBy: ".").joined()
        
        for char in tempText{
            if !char.isNumber{
                return false
            }
        }
        return true
    }

}

extension NewGroceryItemViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let inputText = textField.text else{
            return false
        }
        
        if textField == itemPriceTextField && !areYouANumber(inputText){
            warningLabel.text = "Your price input should be a number."
            return false
        }
        
        if textField == itemPriceTextField{
            newItem.price = Double(inputText) ?? 0.0
            textField.resignFirstResponder()
            warningLabel.text = "Add an item to the List"
            return true
        } else if textField == itemNameTextField{
            newItem.name = textField.text ?? "Unknown item"
            newItem.status = .purchased
            textField.resignFirstResponder()
            return true
        }
        return true
    }
}
