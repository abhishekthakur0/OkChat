//
//  LoginRegisterViewController.swift
//  OkChat
//
//  Created by Abhishek Thakur on 06/12/19.
//  Copyright © 2019 Abhishek Thakur. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginRegisterViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterViewController.dissmissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        if(!CheckInput()){
            return
        }
        let email = emailTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] authResult, error in
            if let error =  error{
                Utilities().showAlert(title: "Error!", message: error.localizedDescription, vc: self!)
                print(error.localizedDescription)
                return
            }
            print("Signed In")
            
        }
        
    }
    func CheckInput() -> Bool {
        
        if (emailTextField.text!.count < 5)
        {
            emailTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        }
        else
        {
            emailTextField.backgroundColor = UIColor.gray
        }
        if (passwordTextField.text!.count < 5)
        {
            passwordTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        }
        else
        {
            passwordTextField.backgroundColor = UIColor.gray
        }
        
        return true
        
        
    }
    @IBAction func signupClicked(_ sender: Any) {
        
        if(!CheckInput()){
            return
        }
        
        let alert = UIAlertController(title: "Register", message: "Please Confirm Password...", preferredStyle: .alert)
        alert.addTextField {(textField) in textField.placeholder = "Password"
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            let passConfirm = alert.textFields![0] as UITextField
            if(passConfirm.text!.isEqual(self.passwordTextField.text!)){
                //Registration Begins Here
                
                let email = self.emailTextField.text
                let password = self.passwordTextField.text
                Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
                    if let error = error {
                        Utilities().showAlert(title: "Error", message: error.localizedDescription, vc: self)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
            }
            else{
                Utilities().showAlert(title: "Error", message: "Password Is Not Same", vc: self)
            }
        }))
        
        self.present(alert,animated: true,completion: nil)
        
    }
    
    @IBAction func forgotClicked(_ sender: Any) {
        if (emailTextField.text!.count < 5)
        {
            emailTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return 
        }
        
        let resEmail = emailTextField.text
        Auth.auth().sendPasswordReset(withEmail: resEmail!) { error in
            DispatchQueue.main.async {
                if error != nil {
                    // YOUR ERROR CODE
                    Utilities().showAlert(title: "Error", message: "We Got Some Error Try Again Later", vc: self)
                } else {
                    //YOUR SUCCESS MESSAGE
                    Utilities().showAlert(title: "Hurray", message: "A Reset Email has been sent...", vc: self)
                }
            }
            
            
        }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
