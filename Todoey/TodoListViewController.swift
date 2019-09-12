//
//  ViewController.swift
//  Todoey
//
//  Created by Deep Patel on 9/11/19.
//  Copyright © 2019 Deep Patel. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK - tableView datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get reusable cell from identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCells", for: indexPath)
        
        //set text field for each cell item
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        
        //toggle accesssoryType checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        //style change to not leave highlight on selected row ie deselect after click
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - bar button actions
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        //variable to store the new input from user and pass between controller and alert actions
        var itemCreated = UITextField()
        
        let alert = UIAlertController(title: "Add an To Do Item", message: "", preferredStyle: .alert)
        
        //this action will finish before controller method finishes
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            
            //append the item array
            self.itemArray.append(itemCreated.text!)
            //reload the datasource afterwords to see changes on screen
            self.tableView.reloadData()
            
        }
        
        //add a text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            itemCreated = alertTextField
        }
        
        //add action to alert
        alert.addAction(action)
        
        //present the alert controller
        present(alert, animated: true, completion: nil)
    }
}

