//
//  StudentDetails.swift
//  On The Map
//
//  Created by LIJO RAJU on 16/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import Foundation

// MARK: Structure storing each studenLocation
struct StudentDetails {
    var name = ""
    var latitude = 0.0
    var longitude = 0.0
    var mediaURL = ""
    
    // MARK: Structure intialization
    init(data:[String: AnyObject]) {
        if let firstname = data["firstName"] as? String , let lastname = data["lastName"] as? String {
            name = firstname + " " + lastname
        }
        
        if let lat = data["latitude"] as? Double, let long = data["longitude"] as? Double, let URL = data["mediaURL"] as? String {
            latitude = lat
            longitude = long
            mediaURL = URL
        }
        
    }

}


        
