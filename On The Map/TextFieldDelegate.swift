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
    
    // MARK: Overwrite alert
    func showDoubleAlert(title: String, message: String, identifier: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result: UIAlertAction)-> Void in
           // self.setUIEnabled(true)
        }
        
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (result: UIAlertAction)-> Void in
            performUIUpdatesOnMain {
                //self.setUIEnabled(true)
                self.performSegue(withIdentifier: identifier, sender: self)
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(overwriteAction)
        present(alert, animated: true, completion: nil)
    }

}
