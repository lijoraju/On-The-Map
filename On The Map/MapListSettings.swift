//
//  MapListSettings.swift
//  On The Map
//
//  Created by LIJO RAJU on 22/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//


import UIKit
import FBSDKLoginKit

class Settings: UIViewController {
   
    static let sharedInstance = Settings()
    
    // MARK: Refresh map
    func refreshButtonAction(completionHandler: @escaping(_ refresh: Bool, _ error: String?)-> Void) {
        
        // Fetching students infomation from parse API
        StudentLocation.sharedInstance.gettingStudentLocations { (sucess,error) in
            if error != nil {
                completionHandler(false, error)
            }
                
            else {
                completionHandler(true,nil)
            }
            
        }

    }
    
    // MARK: Logout from udacity API
    func logoutButtonAction(completionHandler: @escaping(_ logout: Bool, _ error: String?)-> Void) {
        
        // Logout from facebook
        if StudentsData.sharedInstance.isLoggedInFacebook {
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            StudentsData.sharedInstance.isLoggedInFacebook = false
        }
        
        // Logout from Udacity
        UdacityLogin.sharedInstance.logoutFromUdacity { (sucess,error) in
            if sucess {
                completionHandler(true, nil)
            }
                
            else {
                completionHandler(false, error)
            }
            
        }
        
    }

 }
