//
//  ViewController.swift
//  Todoey
//
//  Created by Deep Patel on 9/11/19.
//  Copyright © 2019 Deep Patel. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    //set to new array of Item object
    var itemArray = [Item]()
    
    //set file path to user directory for app and create new path directory for new plist
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //use the sandbox defaults for app
    let defaults = UserDefaults.standard
    
    //went into UIApplication and shared singleton and cast as app delete to access view context properties
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //using if statement for initial load of local persistence incase its empty which would crash app - then set to itemArray
//        if let items = UserDefaults.standard.array(forKey: "listArrayItem") as? [Item] {
//                    itemArray = items
//            }
        
        //load data from source
        loadData()
    }

    //MARK - tableView datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = itemArray[indexPath.row]
        
        //get reusable cell from identifier
        //deque will reuse and insert cell at the bottom of tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCells", for: indexPath)
        
        //set text field for each cell item
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //Ternary operator: value = condition ? valueIfTrue : valueIfFalse
        //toggle checkmark using ternary instead of ifelse statements
        cell.accessoryType = index.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        
        //set value by key
//        itemArray[indexPath.row].setValue("newChangedValue", forKey: "title")
        
        //short hand toggle bool field for checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
        
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
            let newItem = Item(context: self.viewContext)
            newItem.title = itemCreated.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            //set new entry to itemArray to store - failed to insert new model type only primitive types
//            self.defaults.set(self.itemArray, forKey: "listArrayItem")
            
            self.saveData()
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
    
    
    //MARK - model manipulation
    
    func saveData() {
        //set encoding and writing to custom class list in user defaults file path
//        let encoder = PropertyListEncoder()
        
        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try viewContext.save()
        } catch {
            print("Error saving to database: \(error)")
        }
        
        //reload the datasource afterwords to see changes on screen
        tableView.reloadData()
    }
    
    func loadData(request: NSFetchRequest<Item> = Item.fetchRequest()) {
//        //set variable to filepath
//        if let data = try? Data(contentsOf: dataFilePath!) {
//
//            //create instance of decoder
//            let decoder = PropertyListDecoder()
//
//            //decode from custom list and of type from url
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding from list: \(error)")
//            }
//        }
        
//    let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try viewContext.fetch(request)
        } catch {
            print ("Error retreiving data: \(error)")
        }
            tableView.reloadData()
    }
}


//MARK - extension to help seperate concerns and for debugging
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let nsRequest : NSFetchRequest<Item> = Item.fetchRequest()
        
        //[cd] is to allow for case & díàcritic results
        nsRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sorting order for the search request
        let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
        
        nsRequest.sortDescriptors = sortDescriptor
        
        loadData(request: nsRequest)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            //reload the original data without parameters
            loadData()
            
            //resign the search bar running on the main thread?? to remove keyboard from view and unselect the searchbar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}

