//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by LIJO RAJU on 21/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping ()-> Void ) {
    DispatchQueue.main.async {
        updates()
    }
    
}
