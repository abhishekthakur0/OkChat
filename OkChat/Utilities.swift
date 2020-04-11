//
//  Utilities.swift
//  OkChat
//
//  Created by Abhishek Thakur on 11/04/20.
//  Copyright © 2020 Abhishek Thakur. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    func showAlert(title: String, message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert,animated: true,completion: nil)
    }
}
