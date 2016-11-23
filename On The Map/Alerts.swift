//
//  Alerts.swift
//  On The Map
//
//  Created by LIJO RAJU on 15/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//


import  UIKit

class Alerts: UIAlertController {
    
    static let sharedObject = Alerts()
    
    // MARK: Single button alert
    func showAlert(controller: UIViewController, title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
       
}
