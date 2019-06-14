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
    // var itemArray = ["Find Nate", "Buy Eggos", "Destroy Demogorgon"]
        var itemArray = [Item]()
    
        // NOTE:  FileManager command below returns an array so adding .first will return just the first array element
        // into the variable dataFilePath.  Not sure under what conditions more than one element [0] is returned.
        //
        // .appendingPathComponent method creates a file with the specified name.
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
 
    
    // initialize an object to access UserDefaults
    // let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath!)
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//        
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
        // Load itemArray from Userdefaults - if there is actually something
        // in Userdefaults named "TodoListArray" - meaning it has previously
        // been stored there by an earlier run of the app
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadData()
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //cell.textLabel?.text = itemArray[indexPath.row]
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
// THE FOLLOWING BLOCK OF CODE IS REPLACED WITH THE LINE ABOVE USING THE TERNARY OPERATOR
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // deselectes the table cell that was just selected (removing the highlight)
        tableView.deselectRow(at: indexPath, animated: true)
        
//        // places or removes a checkmark next at the right side of the table
//        // cell that was just selected.
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        // toggle the "done" property if the cell is selected
        // The next line is the same as the if/else block below it, toggling the boolean value
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        // save itemArray to Items.plist file and refresh the tableView
        self.saveItems()
    
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
                

                
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                
                // save the itemArray to Userdefaults
//                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                // save itemArray to Items.plist file and refresh the tableView
                self.saveItems()
                
            }

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    


//MARK - Model Manipulation Methods

    func saveItems() {
        // use an encoder to store itemArray instead of Userdefaults
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        
        // trigger a refresh of the tableView
        tableView.reloadData()
    }
    
    func loadData() {
        // try? makes the result of the try? (ie; the variable data) an Optional so it can be safely unwrapped in case
        // there is an error (no file yet exists, etc.)
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding data.")
            }

        }
    }

}
