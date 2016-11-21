//
//  UdacityAPI.swift
//  On The Map
//
//  Created by LIJO RAJU on 14/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import Foundation

class UdacityLogin {
    
    // MARK: Info about the user, provided through authentication
    var userKey = ""
    var Name = ""
    var firstName = ""
    var lastName = ""
    
    // MARK: Log into Udacity
    func loginToUdacity(username: String, password: String, completionHandler: @escaping(_ sucess:Bool,_ errorString:String?)-> Void) {
        
        // Get Session ID
        let request = NSMutableURLRequest(url:NSURL(string: "https://www.udacity.com/api/session")! as URL)
        
        // API parameters
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        // Initialize session.
        let session = URLSession.shared
        
        // Initialize task for data retrieval.
        let task = session.dataTask(with: request as URLRequest) { (data,response,error) in
            
            if error != nil {
              
                // MARK: Connection Error
              completionHandler(false, error!.localizedDescription)
                return
            }
            
            // The first five characters must be removed. They are included by Udacity for security purposes.
            let newData = data!.subdata(in:5..<(data!.count))
            let parseResult = (try! JSONSerialization.jsonObject(with: newData, options: .allowFragments)) as! NSDictionary
            
            // MARK: Get user key
            if let userKey = (parseResult["account"] as? [String:Any])? ["key"] as? String {
                
                self.userKey = userKey
                completionHandler(true,nil)
            }
                
            else {
                
                completionHandler(false, "Incorrect Username Password")
            }
            
        }
        
        task.resume()
    }
    
    func setFirstNameLastName(completionHandler: @escaping(_ sucess: Bool, _ errorString: String?)-> Void) {
        
        let request = NSMutableURLRequest(url:NSURL(string:"https://www.udacity.com/api/users/\(self.userKey)")! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data,response,error) in
            
            if error != nil {
                
                // MARK: Connection Error
                return
            }
            
            // The first five characters must be removed. They are included by Udacity for security purposes.
            let newData = data!.subdata(in: 5..<(data!.count))
            let parseResult = (try! JSONSerialization.jsonObject(with: newData, options: .allowFragments)) as! NSDictionary
            
            // MARK: Get first name and last name
            guard let user = (parseResult["user"] as? [String:Any]) else {
                
                completionHandler(false, "Could not retrieve User Info from Udacity.")
                return
            }
            
            if let firstName = user["first_name"] as? String, let lastName = user["last_name"] as? String {
                
                 self.Name = firstName + " " + lastName
                self.firstName = firstName
                self.lastName = lastName
                
            }
           
            completionHandler(true, nil)
        }
        
        task.resume()
    }

    class func sharedInstance()-> UdacityLogin {
    
    struct Singleton {
        
       static let sharedInstance = UdacityLogin()
    }
    
    return Singleton.sharedInstance
   }
    
}
