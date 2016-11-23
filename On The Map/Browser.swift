//
//  Browser.swift
//  On The Map
//
//  Created by LIJO RAJU on 16/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//


import UIKit

class Browser: UIViewController {
    
    // MARK: Open URL in browser
    func Open(Scheme: String) {
        
        if let url = URL(string: Scheme) {
            
            // Opening a URL with iOS 10
            if #available(iOS 10, *) {
                
                UIApplication.shared.open(url, options: [:], completionHandler: { (sucess) in
                    print("Open \(url):\(sucess)")
                })
                
            }
                
                // Opening a URL with iOS 9 or earlier
            else {
                
                let sucess = UIApplication.shared.openURL(url)
                print("Open \(url):\(sucess)")
            }
            
        }
        
    }
    
    // Escaping URL
    func cleanURL(url:String)-> String {
        
        var testURL = url
        if testURL.characters.first != "h" && testURL.characters.first != "H" {
            
            testURL = "http://" + testURL
        }
        
        return String(testURL.characters.filter{!"".characters.contains($0)})
    }
    
    class func sharedInstance()-> Browser {
        
        struct singleton {
            
            static let sharedInstance = Browser()
        }
        
        return singleton.sharedInstance
    }

}
