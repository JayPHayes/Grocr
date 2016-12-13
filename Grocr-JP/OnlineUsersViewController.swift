//
//  OnlineUsersViewController.swift
//  Grocr-JP
//
//  Created by Jay P. Hayes on 12/12/16.
//  Copyright © 2016 Jay P. Hayes. All rights reserved.
//

import UIKit

class OnlineUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Constants
    let userCell = "UserCell"
    
    // MARK: Properties
    var currentUsers: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentUsers.append("hungry@person.food")
        
        
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
