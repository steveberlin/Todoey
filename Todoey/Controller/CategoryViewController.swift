//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Steve Berlin on 6/15/19.
//  Copyright © 2019 Steve Berlin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    
    // Initialize a new Realm
    let realm = try! Realm()  //could return an error but VERY unlikely according to Realm documentation
    // only would throw an error if a new Realm() is created and it fails because of resource constraints.
    // I would still wrap it in a do catch block if this was real code - just to be safe.
    
    // var categoryArray = [Category]()
    // reads of the Realm database return objects of type Results.
    // this command initializes a Results object (like an array) of Category objects
    // Results data type is an auto-updating container
    var categoryArray : Results<Category>?
    
    var itemArray = [Item]()
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none

    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        //return categoryArray.count
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // access the cell in tableView created in the superclass SwipeTableViewController
        // this gives access to the swipable cell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        

        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        guard let categoryColor = UIColor(hexString: categoryArray?[indexPath.row].hexValue ?? "#60a3bc") else {fatalError()}
        
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//
//    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Category context \(error)")
        }
        tableView.reloadData()
    }
    
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching Category data from context \(error)")
//        }
        tableView.reloadData()
    }
    
    override func updateDataModel(at indexPath: IndexPath) {
        print("Item Deleted")
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error deleting category. \(error)")
            }
        }
        //tableView.reloadData() isn't needed because .expansionStyle = .destructive is specified in edit ActionsOptionsForRowAt
        //   this option also deletes the selected row
        //tableView.reloadData()
    }
    
    override func pickNewRandomColor(at indexPath: IndexPath) {
        if let category = categoryArray?[indexPath.row] {
            do {
                try realm.write {
                    category.hexValue = UIColor.randomFlat.hexValue()
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        // deselectes the table cell that was just selected (removing the highlight)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if textField.text != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.hexValue = UIColor.randomFlat.hexValue()
                // the .append command is no longer neaded because categoryArray is an auto-updating object
//                self.categoryArray.append(newCategory)
                self.saveCategories(category: newCategory)
            }
        }
        alert.addAction(action)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // technically this if block is not needed because
        // there is only one segue so it will always report
        // the .identifier "goToItems".
        // if there was more than one segue then this is how
        // you can identify the segue that was selected.
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            // get the catagory that coorespons to the selected cell
        
            // get the currently selected row in the table
            // this could be nil if no row is selected,
            // although it is unlikely this will happen - still
            // should unwrap the Optional value
            if let indexPath = tableView.indexPathForSelectedRow {
                // pass the selectedCategory to the destination ViewController
                destinationVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
    }

}

