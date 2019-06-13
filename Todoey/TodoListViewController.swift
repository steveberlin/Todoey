//
//  ViewController.swift
//  Todoey
//
//  Created by Steve Berlin on 6/12/19.
//  Copyright © 2019 Steve Berlin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    // initial array of to do items
    var itemArray = ["Find Nate", "Buy Eggos", "Destroy Demogorgon"]
    
    // initialize an object to access UserDefaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Load itemArray from Userdefaults - if there is actually something
        // in Userdefaults named "TodoListArray" - meaning it has previously
        // been stored there by an earlier run of the app
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // deselectes the table cell that was just selected (removing the highlight)
        tableView.deselectRow(at: indexPath, animated: true)
        
        // places or removes a checkmark next at the right side of the table
        // cell that was just selected.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
            
       
    
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        // initialize a variable as a empty but not nil.  However,
        // the .text property of the textField object is considered Optional,
        // although it is initialized with a value of "" not nil, when
        // it is dynamically created at run time - at least that's what
        // appears to be happening
        // UITextField used to pass information from the dynamically created
        // text field (alert.addTextField) that is inside the
        // dynamically created UIAlertController which appears
        // as a popup window.
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // When the object textField of type UITextField is created,
            // it's property .text is considered Optional but appears to be
            // initialized with a value of "" rather than nil.  So below,
            // check to see if textField.text is blank before adding it to
            // the item array and then reloading the tableView to reflected
            // the new addition of data to the array.

            if textField.text != "" {
                // add the new item as a new element to the end of itemArray
                self.itemArray.append(textField.text!)
                // save the itemArray to Userdefaults
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                // trigger a refresh of the tableView
                self.tableView.reloadData()
            }

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

