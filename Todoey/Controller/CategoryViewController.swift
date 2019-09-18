//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Deep Patel on 9/17/19.
//  Copyright © 2019 Deep Patel. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //array of categories
    var categoryArray = [Category]()
    
    //viewcontext to get singleton class and access properties for persistent storage
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategoryData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let index = categoryArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItems", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name

        return cell
    }
    
    //dont need default implementation since only a single column will be in per row
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - data manipulation methods
    
    func loadCategoryData(request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try viewContext.fetch(request)
        } catch {
            print("Error loading Category data: \(error)")
        }
        tableView.reloadData()
    }
    
    func saveCategoryData() {
        do {
        try viewContext.save()
        } catch {
            print("Error saving Category data: \(error)")
        }
        tableView.reloadData()
    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var alertInput = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let categoryCreated = Category(context: self.viewContext)
            categoryCreated.name = alertInput.text
            self.categoryArray.append(categoryCreated)
            
            self.saveCategoryData()
        }
        
        //add textfield to alert and set it equal to variable that can be used in alertcontroller
        alert.addTextField { (textField) in
            textField.placeholder = "Enter New Category"
            alertInput = textField
        }
        
        //add action to alert
        alert.addAction(action)
        
        //present the alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue 
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //if path is not nil for selected row
        if let path = tableView.indexPathForSelectedRow {
            //then set that category name on the todoList to the selected row
            destinationVC.categoryName = categoryArray[path.row]
        }
    }
}
