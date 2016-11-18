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
    
    var Name = ""
    var Latitude = 0.0
    var Longitude = 0.0
    var mediaURL = ""
    
    // MARK: Structure intialization
    init(data:[String: AnyObject]) {
        
        if let firstname = data["firstName"] as? String , let lastname = data["lastName"] as? String {
            
            Name = firstname + " " + lastname
        }
        
        if let Lat = data["latitude"] as? Double, let Long = data["longitude"] as? Double, let URL = data["mediaURL"] as? String {
            
            Latitude = Lat
            Longitude = Long
            mediaURL = URL
        }
        
    }

}


        
