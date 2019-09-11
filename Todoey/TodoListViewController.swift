//
//  ViewController.swift
//  Todoey
//
//  Created by Deep Patel on 9/11/19.
//  Copyright © 2019 Deep Patel. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

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
    

}

