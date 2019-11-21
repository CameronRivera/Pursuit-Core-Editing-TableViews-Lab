//
//  ViewController.swift
//  EditingTableViews
//
//  Created by Cameron Rivera on 11/20/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var groceryItems: [GroceryItem] = [] {
        didSet{
            groceryMatrix = GroceryItem.makeMeAMatrix(outOf: groceryItems)
        }
    }
    var groceryMatrix: [[GroceryItem]] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func addNewGroceryItem(unWindSegue: UIStoryboardSegue){
        guard let newGroceryVC = unWindSegue.source as? NewGroceryItemViewController else{
            fatalError("Could not access source viewController as a NewGroceryItemViewController.")
        }
        
        groceryItems.insert(newGroceryVC.newItem, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
        
        private func setUp(){
            groceryMatrix = GroceryItem.makeMeAMatrix(outOf: groceryItems)
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
        xCell.detailTextLabel?.text = "$\(String(format: "%2.f", groceryMatrix[indexPath.section][indexPath.row].price))"
        return xCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            groceryItems.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

extension TableViewController: UITableViewDelegate{
    
}
