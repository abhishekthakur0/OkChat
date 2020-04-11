//
//  ViewController.swift
//  OkChat
//
//  Created by Abhishek Thakur on 06/12/19.
//  Copyright © 2019 Abhishek Thakur. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //logout
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            print("Error Signin Out"+signOutError.description)
        }
        
        
        
        if Auth.auth().currentUser == nil{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "firebaseLoginViewController")
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        // Do any additional setup after loading the view.
    }
    
    
}

