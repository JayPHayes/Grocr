//
//  GroceryListViewController.swift
//  Grocr-JP
//
//  Created by Jay P. Hayes on 12/12/16.
//  Copyright © 2016 Jay P. Hayes. All rights reserved.
//

import UIKit
import Firebase

class GroceryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    let listToUsers = "ListToUsers"
    let ref = FIRDatabase.database().reference(withPath: "grocery-items")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    
    
    //MARK: properties
    var items: [GroceryItem] = []
    var user: User!
    var btnUserCount: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.allowsSelectionDuringEditing = false
        
        btnUserCount = UIBarButtonItem(title: "1", style: .plain, target: self, action: #selector(btnUserCountTapped) )
        navigationItem.leftBarButtonItem = btnUserCount
        
        user = User(uid: "FakeID", email: "hungry@person.food")
     
        ref.queryOrdered(byChild: "completed").observe(.value, with:{ snapshot in
            var newItems: [GroceryItem] = []
            
            for item in snapshot.children {
                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            self.items = newItems
            self.tableView.reloadData()
            
        })

    
        // Firebase Authentication
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            guard let user = user else {return}
            self.user = User(authData: user)
            
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        // ** Updating online user counts
        usersRef.observe(.value, with:{ snapshot in
            if snapshot.exists() {
                self.btnUserCount?.title = snapshot.childrenCount.description
            } else {
                self.btnUserCount?.title = "0"
            }
        })
    }
    
    
    func btnUserCountTapped() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }


    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let groceryItem = items[indexPath.row]
        
        cell.textLabel?.text = groceryItem.name
        cell.detailTextLabel?.text = groceryItem.addedByUser
        
        toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
//            items.remove(at: indexPath.row)
//            tableView.reloadData()
            
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        let groceryItem = items[indexPath.row]
        let toggleCompletion = !groceryItem.completed
        toggleCellCheckbox(cell, isCompleted: toggleCompletion)
        groceryItem.ref?.updateChildValues(["completed": toggleCompletion])
        
//        var groceryItem = items[indexPath.row]
//        let toggledCompletion = !groceryItem.completed
//        
//        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
//        groceryItem.completed = toggledCompletion
//        
//        items[indexPath.row] = groceryItem
//        tableView.reloadData()
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }

    
   //MARK - button Methods
    @IBAction func btnAdd(_ sender: Any) {
        
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        // 1
                                        guard let textField = alert.textFields?.first,
                                            let text = textField.text else { return }
                                        
                                        // 2
                                        let groceryItem = GroceryItem(name: text,
                                                                      addedByUser: self.user.email,
                                                                      completed: false)
                                        // 3
                                        let groceryItemRef = self.ref.child(text.lowercased())
                                        
                                        // 4
                                        groceryItemRef.setValue(groceryItem.toAnyObject())
        }
        
        
       
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    
    
    
    
    
    

}
