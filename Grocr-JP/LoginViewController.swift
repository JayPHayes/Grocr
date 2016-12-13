//
//  LoginViewController.swift
//  Grocr-JP
//
//  Created by Jay P. Hayes on 12/12/16.
//  Copyright © 2016 Jay P. Hayes. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: Constants
    let loginToList = "LoginToList"


    //MARK: - Outlets
    @IBOutlet weak var txtEmailLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //01
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        //01
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            if user != nil {
                //03
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
            
        }
        
//        performSegue(withIdentifier: loginToList, sender: nil)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        //01 Get Email and password
                                        let txtEmail = alert.textFields![0]
                                        let txtPassword = alert.textFields![1]
                                        
                                        //02: Create User
                                        FIRAuth.auth()!.createUser(withEmail: txtEmail.text!, password: txtPassword.text!, completion: { (user, error) in
                                            if error  == nil {
                                                //03: Sign in
                                                FIRAuth.auth()!.signIn(withEmail: txtEmail.text!, password: txtPassword.text!, completion: nil)
                                            }
                                        })
                                    
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
