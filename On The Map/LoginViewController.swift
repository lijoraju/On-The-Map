//
//  LoginViewController.swift
//  On The Map
//
//  Created by LIJO RAJU on 11/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
     
    // MARK: Login with Email Function
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        setUIEnabled(enabled: false)
        if isIncomplete() {
            
            setUIEnabled(enabled: true)
            debugTextLabel.text = "Username and Password can't be empty"
        }
            
        else {
            
            // get userID
            UdacityLogin.sharedInstance().loginToUdacity(username: usernameTextField.text!, password: passwordTextField.text!) { (sucess, error) in
                
                if sucess {
                    
                    print("Login Sucess")
                    
                    // Fetching first and last name from Udacity.
                    UdacityLogin.sharedInstance().setFirstNameLastName() { (sucess, error) in
                        
                        if sucess {
                            
                            // Fetching students information from Parse API.
                            studentLocation.sharedInstance().gettingStudentLocations() { (sucess, error) in
                                
                                if sucess {
                                    
                                    print("Login Complete")
                                    self.completeLogin()
                                }
                                
                                else {
                                    
                                    // MARK: Error fetching students information from Parse API.
                                    performUIUpdatesOnMain {
                                        
                                        Alerts.sharedObject.showAlert(controller: self, title: "Fetch Info", message: error!)
                                        self.setUIEnabled(enabled: true)
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        else {
                            
                            // MARK: Error fetching first and last name from Udacity.
                            performUIUpdatesOnMain {
                                
                                Alerts.sharedObject.showAlert(controller: self, title: "JSON Error", message: error!)
                                self.setUIEnabled(enabled: true)
                            }
                            
                        }
                        
                    }
                    
                }
                    
                else {
                    
                    // MARK: Login Error
                    performUIUpdatesOnMain {
                        
                        Alerts.sharedObject.showAlert(controller: self, title: "Login Failed", message: error!)
                        self.setUIEnabled(enabled: true)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: Account Sign Up
    @IBAction func accountSignUp(_ sender: AnyObject) {
        
        Browser.sharedInstance().Open(Scheme: "https://www.udacity.com/account/auth#!/signup")
    }

    // MARK: Configure UI
    private func setUIEnabled(enabled:Bool) {
    
    usernameTextField.isEnabled = enabled
    passwordTextField.isEnabled = enabled
    debugTextLabel.text = ""
    loginButton.isEnabled = enabled
    if enabled {
        
        loginButton.alpha = 1.0
        usernameTextField.alpha = 1.0
        passwordTextField.alpha = 1.0
    }
        
    else {
        
        loginButton.alpha = 0.5
        usernameTextField.alpha = 0.5
        passwordTextField.alpha = 0.5
        }
    
    }
    
    // MARK: Check Input text
    func isIncomplete()->Bool {
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            return true
        }
        
        return false
  
    }
    
    // MARK: Complete Login
    func completeLogin() {
        
        performUIUpdatesOnMain {
            
           self.performSegue(withIdentifier: "LoginToTabBar", sender: self)
        }
        
    }
    
}



