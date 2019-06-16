//
//  ViewController.swift
//  Todoey
//
//  Created by Steve Berlin on 6/12/19.
//  Copyright © 2019 Steve Berlin. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    // initial array of to do items
    // var itemArray = ["Find Nate", "Buy Eggos", "Destroy Demogorgon"]
        var itemArray = [Item]()
    
        // NOTE:  FileManager command below returns an array so adding .first will return just the first array element
        // into the variable dataFilePath.  Not sure under what conditions more than one element [0] is returned.
        //
        // .appendingPathComponent method creates a file with the specified name.
        //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // UIApplication.shared - references the Singleton of the instance of the app when it is actually runing
    // .delegate references delegates of the app, ie; as defined in AppDelegate.sift,
    // and is downcast (as!) using the class AppDelegate
    // .persistentContainer.viewContext are the context (temporary working area) of the CoreData SQLite database
    // as defined in AppDelegate.swift
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    
    // initialize an object to access UserDefaults
    // let defaults = UserDefaults.standard
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set self as the delegate of the search bar
        searchBar.delegate = self
        
        //print(dataFilePath!)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        
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
                

                
                //let newItem = Item()
                // define a new item as the context (temporary working area) of the CoreData model object Item
                let newItem = Item(context: self.context)
                
                newItem.title = textField.text!
                newItem.done = false
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
        // let encoder = PropertyListEncoder()
        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
        } catch {
//            print("Error encoding item array, \(error)")
            print("Error saving conext \(error)")
        }
        
        
        // trigger a refresh of the tableView
        tableView.reloadData()
    }
    // with = external parameter
    // request = internal parameter
    // NSFetchRequest<Item> data type
    // = Item.fetchRequest() = provides a default value for for the request if no value is passed to the array
    // eg; calling loadData() without an argument creates a default blank request of type NSFetchRequest<Item> with the default value Item.fetchRequest()
    // calling loadData(request) with a NSFetchRequest already created, which could include custom .predicate and .sortDescriptors will use the passed argument
    // as the request.
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        // try? makes the result of the try? (ie; the variable data) an Optional so it can be safely unwrapped in case
        // there is an error (no file yet exists, etc.)
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding data.")
//            }
//
//        }
        
        // this request will fetch results in the form specified by the Item data model
        // NSFetchRequest<Item> specifies that request is of type NSFetchRequest and it will return an array of Item(s) <Item>
        //      NOTE:  because the request is passed in as a parameter of the function --OR-- if no request is passed in a default request is created,
        //      it is not necessary to initialize a blank request inside the function.
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            // the .fetch below is a blank request that pulls back everything in the persistent container
            // specified by context
            // This method has an output returning an NSFetchRequest result which will be an array if Item(s) and it
            // is saved into the array itemArray
            // NOTE:  each item in the array is a NSManagedObject, and each one of these array items (ie; NSManagedObjects)
            // represents a database row, which is made up of database fields (ie; Core Data attributes, or Class properties)
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()
        
        
    }
    


}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
//        let predicate = NSPredicate(format: "title INCLUDES[cd] %@", searchBar.text!)
//        request.predicate = predicate
        // line below is a refactored form of the above two lines
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        // NOTE:  request.sortDescriptors is an array.  In our case we are only specifying one sort descriptor but we still have to make it an array, so
//        // we place brackets around it to make it an array of a single element.
//        request.sortDescriptors = [sortDescriptor]
        // line below is a refactored form of the above two code lines.  NOTE the use of [] around NSSortDescriptor to create an array as is expected by .sortDescriptors
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // make the fetch request with the predicate and sortDescriptors
        loadData(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // THis function is triggered any time text is the search bar is changed.  The if statement below looks for the case when
        // the count of letters in the searchBar text field becomes 0, meaning it has become blank, either when backspaced entirely
        // or the x is selected to erease all existing text in the text bar.
        
        // If that is the case, eg; no text in the search bar, then reload data with no filter, eg. no request is passed
        // to the loadData() function, in which case the function is setup to provide a blank fetchReques which will then
        // fetch all data, unfiltered, from the CoreData SQLite database.
        
        if searchBar.text?.count == 0 {
            loadData()
            
            // DispatchQueue.main.async {} is a block of code that will be run on the main thread of the application,
            // this is where changes to the user interface should happen.
            DispatchQueue.main.async {
                //resignFirstResponder() method tells an element, in this case searchBar, it should no longer be the thing that is currently selected,
                //it no longer has the cursor and the keyboard should be dismissed.  We want his to happen in the foreground (main thread) so it is done inside a
                //DispatchQueue.main.async block.
                searchBar.resignFirstResponder()
            }
            

        } else {
            // NOTE:  This is the same code as in the func searchBarSearchButtonClicked()
            // this should cause the search to happen automatically each time the text in the searchBar is changed,
            // not only when the Search button is pressed.
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            //        let predicate = NSPredicate(format: "title INCLUDES[cd] %@", searchBar.text!)
            //        request.predicate = predicate
            // line below is a refactored form of the above two lines
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            //        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            //        // NOTE:  request.sortDescriptors is an array.  In our case we are only specifying one sort descriptor but we still have to make it an array, so
            //        // we place brackets around it to make it an array of a single element.
            //        request.sortDescriptors = [sortDescriptor]
            // line below is a refactored form of the above two code lines.  NOTE the use of [] around NSSortDescriptor to create an array as is expected by .sortDescriptors
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            // make the fetch request with the predicate and sortDescriptors
            loadData(with: request)
        }
    }
}
