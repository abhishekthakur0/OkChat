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
    
    var ref:DatabaseReference!
    private var refHandler:DatabaseHandle!
    
    @IBOutlet weak var textView: UITextField!
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
    
    deinit {
        self.ref.child("messages").removeObserver(withHandle: refHandler)
    }
    
    func ConfigureDatabase(){
        ref = Database.database().reference()
        refHandler = self.ref.child("messages").observe(.childAdded, with: { (snapshot) -> Void in
            self.messages.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic   )
        })
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
        let text = message[Constants.messageFields.text]! as String
        cell.textLabel?.text = text
        return cell
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let data = [Constants.messageFields.text:textField.text! as String]
        sendMessage(data: data)
        print("End Of Message")
        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textView.delegate = self
        ConfigureDatabase()

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    func sendMessage(data:[String:String]){
        let packet = data
        self.ref.child("messages").childByAutoId().setValue(packet)
    }
    @objc func keyBoardWillHide(_ sender: NSNotification){
        let userInfo = sender.userInfo!
        let keyboardSize:CGSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGSize

        self.view.frame.origin.y += keyboardSize.height

        
    }
    @objc func keyBoardWillShow(_ sender: Notification){
        let userInfo = sender.userInfo!
        let keyboardSize:CGSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGSize
        let offSet:CGSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGSize
//        let userInfo:[NSObject: AnyObject] = sender.userInfo!
//        let keyboardSize:CGSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey].cgReactValue().size
//
//        let offSet:CGSize = userInfo[UIKeyboardFrameEndUserInfoKey].cgReactValue.size

        if keyboardSize.height == offSet.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.15) {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
        else{
            UIView.animate(withDuration: 0.15) {
                self.view.frame.origin.y += keyboardSize.height - offSet.height
            }
        }


    }
    
    
}

