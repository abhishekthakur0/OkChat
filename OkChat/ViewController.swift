//
//  ViewController.swift
//  OkChat
//
//  Created by Abhishek Thakur on 06/12/19.
//  Copyright © 2019 Abhishek Thakur. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    var messages: [DataSnapshot]! = [DataSnapshot]()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let messageSnap: DataSnapshot! = self.messages[indexPath.row]
        let message = messageSnap.value as! Dictionary<String,String>
        let text = message["text"]! as String
        cell.textLabel?.text = text
        return cell
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("End Of Message")
        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
}

