//
//  ViewController.swift
//  Todoey
//
//  Created by Deep Patel on 9/11/19.
//  Copyright © 2019 Deep Patel. All rights reserved.
//

import UIKit
import RealmSwift
//import CoreData

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //set to new results container of Item object
    var itemContainer : Results<Item>?
    
    var categoryName : Category? {
        //on setting on this propert y - load the data associated with the selected view
        didSet {
            loadData()
        }
    }
    
    
    //set file path to user directory for app and create new path directory for new plist
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //use the sandbox defaults for app
//    let defaults = UserDefaults.standard
    
    //went into UIApplication and shared singleton and cast as app delegate to access view context properties
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //using if statement for initial load of local persistence incase its empty which would crash app - then set to itemArray
//        if let items = UserDefaults.standard.array(forKey: "listArrayItem") as? [Item] {
//                    itemArray = items
//            }
        
        //load data from source
        loadData()
    }

    //MARK - tableView datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get reusable cell from identifier
        //deque will reuse and insert cell at the bottom of tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCells", for: indexPath)
        
        //if item results has value then set the accesory type else just let user know there is not items yet
        if let index = itemContainer?[indexPath.row] {
            //set text field for each cell item
            cell.textLabel?.text = itemContainer?[indexPath.row].title
            
            //Ternary operator: value = condition ? valueIfTrue : valueIfFalse
            //toggle checkmark using ternary instead of ifelse statements
            cell.accessoryType = index.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemContainer?.count ?? 1
    }
    
    
    //MARK - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        
        //set value by key
//        itemArray[indexPath.row].setValue("newChangedValue", forKey: "title")
        
        //short hand toggle bool field for checkmark
//        itemContainer[indexPath.row].done = !itemContainer[indexPath.row].done
//        saveData()
        
        if let item = itemContainer?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error updating done..: \(error)")
            }
        }
        
        tableView.reloadData()
        
        //style change to not leave highlight on selected row ie deselect after click
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - bar button actions
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        //variable to store the new input from user and pass between controller and alert actions
        var itemCreated = UITextField()
        
        let alert = UIAlertController(title: "Add a To Do Item", message: "", preferredStyle: .alert)
        
        //this action will finish before controller method finishes
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            
            if let currentCategory = self.categoryName {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = itemCreated.text!
                        //            newItem.done = false -- doesn't need to be declared since default from class is false
                        //use the other relationship to pass value in and append to the object type
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving..: \(error)")
                }
            }

            self.tableView.reloadData()
            
            //set new entry to itemArray to store - failed to insert new model type only primitive types using pList implementation
//            self.defaults.set(self.itemArray, forKey: "listArrayItem")
            
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
    //old save data function using pList encoder and core data
//    func saveData() {
//        //set encoding and writing to custom class list in user defaults file path
////        let encoder = PropertyListEncoder()
//
//        do {
////            let data = try encoder.encode(itemArray)
////            try data.write(to: dataFilePath!)
//            try viewContext.save()
//        } catch {
//            print("Error saving to database: \(error)")
//        }
//        tableView.reloadData()
//    }
    
    
    //set default value for predicate to nil for initial load and then let it take on pass by value arguments after - old load method using core data
//    func loadData(request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
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
//
////    let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //match the predicate to only retrieve items that match the name of the parent category
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName!.name!)
//
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
////
////        request.predicate = compoundPredicate
//
//        //compound predicate and rewrite the previous lines with optional binding
//        if let passedPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, passedPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try viewContext.fetch(request)
//        } catch {
//            print ("Error retreiving data: \(error)")
//        }
//            tableView.reloadData()
//    }
    
    func loadData() {
        //return all items from category 
        itemContainer = categoryName?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}


//MARK - extension to help seperate concerns and for debugging
extension TodoListViewController : UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let nsRequest : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //[cd] is to allow for case & díàcritic results
//        nsRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //sorting order for the search request
//        let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
//
//        nsRequest.sortDescriptors = sortDescriptor
//
//        //pass in the new parameter for predicate
//        loadData(request: nsRequest, predicate: nsRequest.predicate)
//    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //filter and sort in one call
        itemContainer = itemContainer?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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

