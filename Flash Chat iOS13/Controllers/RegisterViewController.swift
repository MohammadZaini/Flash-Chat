//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error {
                    
                    self.showAnAlert(withError: e.localizedDescription);

                } else {
        
                    self.performSegue(withIdentifier: K.registerSegue, sender: self);
                }
            }
        }
    }
    
    func showAnAlert(withError: String){
        
        let alertController = UIAlertController(title: "Error", message: withError, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default);
        
        alertController.addAction(action)

        self.present(alertController, animated: true, completion: nil)
    }
    
}
