//
//  ParseAPI.swift
//  On The Map
//
//  Created by LIJO RAJU on 15/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import Foundation

class StudentLocation {
    
    // These shared keys are used by all students in Udacity.com's "iOS Networking with Swift" course.
    let Parse_ApplicationID = Constants.Parse_ApplicationID
    let REST_APIKey = Constants.REST_APIKey
    
    // MARK: Fetching student locations from Parse API
    func gettingStudentLocations(completionHandler: @escaping (_ sucess: Bool, _ errorString: String?)-> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue(self.Parse_ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.REST_APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // Initialize session.
        let session = URLSession.shared
        
        // Initialize task for data retrieval.
        let task = session.dataTask(with: request as URLRequest) { (data,response,error) in
            
            if error != nil {
                
             completionHandler(false, error!.localizedDescription)
                return
            }
            
            // Parsing data
            let parseResult = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
            if let results = parseResult["results"] as? [[String:AnyObject]] {
                
                // MARK: Retrieving each StudentLocation information
                for result in results {
                  
                    StudentsData.sharedInstance().mapPins.append(StudentDetails.init(data: result))
                }
                
                completionHandler(true, nil)
            }
            
            else {
                
                completionHandler(false, "Could not find key 'results' in \(parseResult)")
            }
            
        }
        
        task.resume()
    }
    
    //Submit a student information node to Parse.
    func postingStudentLocation(_ latitude: String, longitude: String, addressField: String, link: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(Constants.Parse_ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.REST_APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //API Parameters.
        request.httpBody = "{\"uniqueKey\": \"\(UdacityLogin.sharedInstance().userKey)\", \"firstName\": \"\(UdacityLogin.sharedInstance().firstName)\", \"lastName\": \"\(UdacityLogin.sharedInstance().lastName)\",\"mapString\": \"\(addressField)\", \"mediaURL\": \"\(link)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        //Initialize session.
        let session = URLSession.shared
        
        //Initialize task for data retrieval.
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if error != nil {
                completionHandler(false, "Failed to submit data.")
            } else {
                completionHandler(true, nil)
            }
        })
        task.resume()
    }

    
    class func sharedInstance()-> StudentLocation  {
        
        struct Singleton {
            
          static let sharedInstance = StudentLocation()
        }
        
        return Singleton.sharedInstance
    }
    
}
