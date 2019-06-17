//
//  ViewController.swift
//  Todoey
//
//  Created by Steve Berlin on 6/12/19.
//  Copyright © 2019 Steve Berlin. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    // initial array of to do items
    // var itemArray = ["Find Nate", "Buy Eggos", "Destroy Demogorgon"]
//        var itemArray = [Item]()
    var todoItems: Results<Item>?  //itemArray is not really an array anymore - it is an autoupdating Realm container object
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        // didSet block runs when selectedCategory is initialized
        didSet {
           loadItems()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        
        tableView.rowHeight = 60
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
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
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
                // if you wanted to delete an item instead of marking it with a check mark you would you the try block
                // below instead of the try block above
                //                try realm.write {
                //                    realm.delete(item)
                //                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
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
                            newItem.dateCreated = Date()
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

    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateDataModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
//                 if you wanted to delete an item instead of marking it with a check mark you would you the try block
//                 below instead of the try block above
                try realm.write {
                    realm.delete(item)
                                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
    }
    
}

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            // if search bar is cleared, call loadData() to reload all data with no filter
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        } else {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
            tableView.reloadData()
        }
    }
}
