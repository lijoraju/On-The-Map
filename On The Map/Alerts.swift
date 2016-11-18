//
//  Alerts.swift
//  On The Map
//
//  Created by LIJO RAJU on 15/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import Foundation
import  UIKit

class Alerts: UIAlertController {
    
    static let sharedObject = Alerts()
    
    // MARK: Single button alert
    func showAlert(controller: UIViewController, title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Double button alert
    func showDoubleAlert(controller: UIViewController, title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (result: UIAlertAction)-> Void in
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "MapToPin", sender: self)
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(overwriteAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
}
