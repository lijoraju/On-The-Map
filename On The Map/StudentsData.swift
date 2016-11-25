//
//  StudentData.swift
//  On The Map
//
//  Created by LIJO RAJU on 16/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import Foundation

class StudentsData: NSData {
    
    // Each pin on the map is a StudentLocation object.
    var mapPins = [StudentDetails]()
    var isLoggedInFacebook = false
    
    // Allows other classes to reference a common instance of the mapPins array.
     static let sharedInstance = StudentsData()
}
