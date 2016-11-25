//
//  TextFieldDelegate.swift
//  On The Map
//
//  Created by LIJO RAJU on 24/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    // MARK: This method is called for the text field to process the pressing of the return button.
    func textFieldShouldReturn(_ textField: UITextField)-> Bool {
        
        // Dismiss keyboard
        textField.endEditing(true)
        
        return true
    }
    
}

extension UIViewController {
    
    // MARK: Close keyboard by touching anywhere
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
