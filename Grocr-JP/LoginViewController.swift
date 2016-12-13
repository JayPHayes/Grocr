//
//  LoginViewController.swift
//  Grocr-JP
//
//  Created by Jay P. Hayes on 12/12/16.
//  Copyright © 2016 Jay P. Hayes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Constants
    let loginToList = "LoginToList"


    //MARK: - Outlets
    @IBOutlet weak var txtEmailLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        performSegue(withIdentifier: loginToList, sender: nil)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}





extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmailLogin {
            txtPassword.becomeFirstResponder()
        }
        if textField == txtPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
