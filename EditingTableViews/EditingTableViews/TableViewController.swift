//
//  ViewController.swift
//  EditingTableViews
//
//  Created by Cameron Rivera on 11/20/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var groceryTableView: UITableView!
    
    var groceryItems: [GroceryItem] = []
    var groceryMatrix: [[GroceryItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUp()
        groceryTableView.dataSource = self
        groceryTableView.delegate = self
    }

    @IBAction func addNewGroceryItem(unWindSegue: UIStoryboardSegue){
        guard let newGroceryVC = unWindSegue.source as? NewGroceryItemViewController else{
            fatalError("Could not access source viewController as a NewGroceryItemViewController.")
        }
        
        
        insertIntoMatrix(aNew: newGroceryVC.newItem)
        groceryTableView.reloadData()
//        let indexPath = IndexPath(row: 0, section: 0)
//        groceryTableView.insertRows(at: [indexPath], with: .automatic)
        
        
    }
        
    private func setUp(){
        groceryMatrix = GroceryItem.makeMeAMatrix(outOf: groceryItems)
    }
    
    private func findProperSection(_ item: GroceryItem) -> Int{
        var section: Int = -1
        
        for (index, element) in groceryMatrix.enumerated(){
            if element.count == 0 {
                continue
            }
            else if element.first?.status == item.status{
                section = index
            }
        }
        
        return section
    }
    
    private func insertIntoMatrix(aNew: GroceryItem){
        var numOfIndices = 0
        var emptyIndex = -1
        var inserted: Bool = false
        
        for (index,element) in groceryMatrix.enumerated(){
            if element.isEmpty{
                emptyIndex = index
            } else if element.first?.status == aNew.status{
                groceryMatrix[index].insert(aNew, at: 0)
                inserted = true
            }
        }
        
        if emptyIndex == -1 && !inserted {
            numOfIndices = groceryMatrix.count
            groceryMatrix.append([GroceryItem]())
            groceryMatrix[numOfIndices].insert(aNew, at: 0)
        } else if emptyIndex != -1 && !inserted{
            groceryMatrix[emptyIndex].insert(aNew, at: 0)
        }
    }
}

extension TableViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return groceryMatrix.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groceryMatrix[section].first?.status.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryMatrix[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let xCell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath)
        xCell.textLabel?.text = groceryMatrix[indexPath.section][indexPath.row].name
        xCell.detailTextLabel?.text = "$\(String(format: "%.2f", groceryMatrix[indexPath.section][indexPath.row].price))"
        return xCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            groceryMatrix[indexPath.section].remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

extension TableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Change the value in the underlying array.
        // Add it to the proper position in the array.
        // Add it to the proper position in the matrix.
        // Remove it from the former section in the table.
        // Add it to the first position in the new section.
        let tempItem = groceryMatrix[indexPath.section].remove(at: indexPath.row)
        tempItem.toggleStatus()
        print("The value of indexPath.row is equal to \(indexPath.row)")
        print("The list item \(tempItem.name) has a status of \(tempItem.status)")
        insertIntoMatrix(aNew: tempItem)
        print (findProperSection(tempItem))
        print("The count of the matrix is \(groceryMatrix.count)")
        groceryTableView.reloadData()
//        let secondIndexPath = IndexPath(row: 0, section: findProperSection(tempItem))
//        tableView.beginUpdates()
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        tableView.insertRows(at: [secondIndexPath], with: .automatic)
//        tableView.endUpdates()
    }
}
