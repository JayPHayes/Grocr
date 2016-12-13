//
//  OnlineUsersViewController.swift
//  Grocr-JP
//
//  Created by Jay P. Hayes on 12/12/16.
//  Copyright © 2016 Jay P. Hayes. All rights reserved.
//

import UIKit
import Firebase

class OnlineUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let userRef = FIRDatabase.database().reference(withPath: "online")
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Constants
    let userCell = "UserCell"
    
    // MARK: Properties
    var currentUsers: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        //currentUsers.append("hungry@person.food")
        userRef.observe(.childAdded, with:{ snap in
            guard let email = snap.value as? String else { return }
            self.currentUsers.append(email)
            
            let row = self.currentUsers.count  - 1 //????
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .top)
            
        })
        
        // Remove users when the go off line
        userRef.observe(.childRemoved, with: {snap in
            guard let emailToFind = snap.value as? String  else { return }
            
            for (index, email) in self.currentUsers.enumerated() {
                if email == emailToFind {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.currentUsers.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        })
        
        
    }

    
    
    //MARK: Table View Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    //MARK: Button Actions
    
    @IBAction func btnSignoutPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
   }
