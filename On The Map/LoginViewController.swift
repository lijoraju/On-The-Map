//
//  LoginViewController.swift
//  On The Map
//
//  Created by LIJO RAJU on 11/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    let textFieldDelegate = TextFieldDelegate()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  

    override func viewDidLoad() {
        
        super.viewDidLoad()
        usernameTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate
        self.hideKeyboardWhenTappedAround()
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
                            StudentLocation.sharedInstance().gettingStudentLocations() { (sucess, error) in
                                
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

    // MARK: Facebook Login button action
    @IBAction func loginFacebook(_ sender: AnyObject) {
        
        setUIEnabled(enabled: false)
        let login = FBSDKLoginManager()
        login.loginBehavior = FBSDKLoginBehavior.systemAccount
        login.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (result, error) in
            
            if error != nil {
                
                // MARK: Error Loggin Into Facebook
               performUIUpdatesOnMain {
                    Alerts.sharedObject.showAlert(controller: self, title: "FB Login Error", message: error! as! String)
                    self.setUIEnabled(enabled: true)
                }
                
                self.setUIEnabled(enabled: true)
            }
                
            else if (result?.isCancelled)! {
                
                self.setUIEnabled(enabled: true)
            }
                
            else {
                
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, first_name, last_name"]).start(completionHandler: { (connection, result, error)-> Void in
                    
                    if error != nil {
                        
                        // MARK: Error Getting User Name
                        performUIUpdatesOnMain {
                            
                            Alerts.sharedObject.showAlert(controller: self, title: "Error Getting User", message: error! as! String)
                            self.setUIEnabled(enabled: true)
                        }
                        
                    }
                        
                    else {
                        
                        if let userDetails = result as? [String:String] {
                            
                            let firstName = userDetails["first_name"]!
                            let lastName = userDetails["last_name"]!
                            
                            // Set name From Facebook
                            UdacityLogin.sharedInstance().firstName = firstName
                            UdacityLogin.sharedInstance().lastName = lastName
                            UdacityLogin.sharedInstance().Name = firstName + " " + lastName
                            // Fetching student information from Udacity.
                            StudentLocation.sharedInstance().gettingStudentLocations { (success, errorString) in
                                
                                if success {
            
                                    StudentsData.sharedInstance().isLoggedInFacebook = true
                                    self.completeLogin()
                                }
                                    
                                else {
                                    
                                    // MARK: Error Getting Data from Udacity
                                    performUIUpdatesOnMain {
                                        
                                        Alerts.sharedObject.showAlert(controller: self, title: "Fetch Info", message: errorString!)
                                        self.setUIEnabled(enabled: true)
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                )
            }
            
        }
        
        )

    }
    
    // MARK: Configure UI
    func setUIEnabled(enabled:Bool) {
    
    usernameTextField.isEnabled = enabled
    passwordTextField.isEnabled = enabled
    debugTextLabel.text = ""
    loginButton.isEnabled = enabled
    if enabled {
        
        activityIndicator.stopAnimating()
        loginButton.alpha = 1.0
        usernameTextField.alpha = 1.0
        passwordTextField.alpha = 1.0
    }
        
    else {
        
        activityIndicator.startAnimating()
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
           
            self.setUIEnabled(enabled: true)
            self.passwordTextField.text = nil
            self.performSegue(withIdentifier: "LoginToTabBar", sender: self)
        }
        
    }
    
}


