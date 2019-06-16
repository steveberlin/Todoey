//
//  ViewController.swift
//  Todoey
//
//  Created by Steve Berlin on 6/12/19.
//  Copyright © 2019 Steve Berlin. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    // initial array of to do items
    // var itemArray = ["Find Nate", "Buy Eggos", "Destroy Demogorgon"]
//        var itemArray = [Item]()
    var todoItems: Results<Item>?  //itemArray is not really an array anymore - it is an autoupdating Realm container object
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        // didSet block runs when selectedCategory is initialized
        didSet {
           loadData()
        }
    }
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        todoItems?[indexPath.row].done = !(todoItems[indexPath.row].done)
//
//        saveItems()
        
        // deselectes the table cell that was just selected (removing the highlight)
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != "" {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.done = false
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving Item to Realm \(error)")
                    }
                    
                }
         
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
    


//MARK - Model Manipulation Methods

    func loadData() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    


}

//extension TodoListViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
////        let predicate = NSPredicate(format: "title INCLUDES[cd] %@", searchBar.text!)
////        request.predicate = predicate
//        // line below is a refactored form of the above two lines
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
////        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
////        // NOTE:  request.sortDescriptors is an array.  In our case we are only specifying one sort descriptor but we still have to make it an array, so
////        // we place brackets around it to make it an array of a single element.
////        request.sortDescriptors = [sortDescriptor]
//        // line below is a refactored form of the above two code lines.  NOTE the use of [] around NSSortDescriptor to create an array as is expected by .sortDescriptors
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        // make the fetch request with the predicate and sortDescriptors
//        loadData(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // THis function is triggered any time text is the search bar is changed.  The if statement below looks for the case when
//        // the count of letters in the searchBar text field becomes 0, meaning it has become blank, either when backspaced entirely
//        // or the x is selected to erease all existing text in the text bar.
//
//        // If that is the case, eg; no text in the search bar, then reload data with no filter, eg. no request is passed
//        // to the loadData() function, in which case the function is setup to provide a blank fetchReques which will then
//        // fetch all data, unfiltered, from the CoreData SQLite database.
//
//        if searchBar.text?.count == 0 {
//            loadData()
//
//            // DispatchQueue.main.async {} is a block of code that will be run on the main thread of the application,
//            // this is where changes to the user interface should happen.
//            DispatchQueue.main.async {
//                //resignFirstResponder() method tells an element, in this case searchBar, it should no longer be the thing that is currently selected,
//                //it no longer has the cursor and the keyboard should be dismissed.  We want his to happen in the foreground (main thread) so it is done inside a
//                //DispatchQueue.main.async block.
//                searchBar.resignFirstResponder()
//            }
//
//
//        } else {
//            // NOTE:  This is the same code as in the func searchBarSearchButtonClicked()
//            // this should cause the search to happen automatically each time the text in the searchBar is changed,
//            // not only when the Search button is pressed.
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            //        let predicate = NSPredicate(format: "title INCLUDES[cd] %@", searchBar.text!)
//            //        request.predicate = predicate
//            // line below is a refactored form of the above two lines
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            //        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//            //        // NOTE:  request.sortDescriptors is an array.  In our case we are only specifying one sort descriptor but we still have to make it an array, so
//            //        // we place brackets around it to make it an array of a single element.
//            //        request.sortDescriptors = [sortDescriptor]
//            // line below is a refactored form of the above two code lines.  NOTE the use of [] around NSSortDescriptor to create an array as is expected by .sortDescriptors
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            // make the fetch request with the predicate and sortDescriptors
//            loadData(with: request, predicate: predicate)
//        }
//    }
//}
