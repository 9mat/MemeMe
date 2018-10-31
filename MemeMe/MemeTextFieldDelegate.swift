//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by dhlong on 29/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    var isUsingDefaultText: Bool = true

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isUsingDefaultText {
            textField.text = ""
            isUsingDefaultText = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
