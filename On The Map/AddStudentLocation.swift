//
//  AddStudentLocation.swift
//  On The Map
//
//  Created by LIJO RAJU on 18/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import Foundation
import UIKit
import  MapKit

class AddStudentLocation: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    
        var coordinates: CLLocationCoordinate2D!
    
        @IBOutlet weak var mapView: MKMapView!
        @IBOutlet weak var submitButton: UIButton!
        @IBOutlet weak var enterLink: UITextField!
        @IBOutlet weak var where2Study: UILabel!
        @IBOutlet weak var location: UITextField!
        @IBOutlet weak var findLocationOnMap: UIButton!
        @IBOutlet weak var topView: UIView!
        @IBOutlet weak var midView: UIView!
     
        override func viewDidLoad() {
            super.viewDidLoad()
            enterLink.delegate = self
            location.delegate = self
            displayOriginalUI()
     
        }
     
        @IBAction func cancelAction(_ sender: AnyObject) {
        
            self.dismiss(animated: true, completion: nil)
        }
     
     func displayOriginalUI() {
     
        mapView.isHidden = true
        submitButton.isHidden = true
        enterLink.isHidden = true
     }
    
     @IBAction func findLocationOnMap(_ sender: AnyObject) {
        
        self.setUIEnabled(enabled: false)
        let location = self.location.text
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location!, completionHandler: { (placemark, error)-> Void in
     
            if error != nil {
     
                performUIUpdatesOnMain {
     
                    Alerts.sharedObject.showAlert(controller: self, title: "Geocoder Error", message: "Could not find location.Please enter a valid location")
                }
                self.setUIEnabled(enabled: true)
     
            }
     
            else if placemark?[0] != nil {
     
                let placemark: CLPlacemark = placemark![0]
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                self.mapView?.addAnnotation(pointAnnotation)
                self.mapView?.centerCoordinate = coordinates
                self.mapView?.camera.altitude = 20000
                self.coordinates = coordinates
                self.displayLocation()
     
            }
     
        } )
     
    }
     
       @IBAction func submitStudentLocation(_ sender: AnyObject) {
     
     self.setUIEnabled(enabled: false)
     studentLocation.sharedInstance().postingStudentLocation(coordinates.latitude.description , longitude: coordinates.longitude.description, addressField: location.text!, link: enterLink.text!) { (sucess,error) in
     
     if sucess {
     
     performUIUpdatesOnMain {
        
        self.dismiss(animated: true, completion: nil)
        }
     
     }
     
     else {
     
     performUIUpdatesOnMain {
     
     Alerts.sharedObject.showAlert(controller: self, title: "Location posting error", message: error!)
                }
        
            }
        
        }
     
     }
   
        func displayLocation() {
     
            setUIEnabled(enabled: true)
            findLocationOnMap.isHidden = true
            mapView.isHidden = false
            enterLink.isHidden = false
            where2Study.isHidden = true
            submitButton.isHidden = false
            midView.isHidden = true
            topView.isHidden = false
        }
     
        func setUIEnabled(enabled: Bool) {
     
            location.isEnabled = true
            submitButton.isEnabled = true
            findLocationOnMap.isEnabled = true
            enterLink.isEnabled = true
            if enabled {
     
                location.alpha = 1.0
                submitButton.alpha = 1.0
                findLocationOnMap.alpha = 1.0
                enterLink.alpha = 1.0
                mapView.alpha = 1.0
                where2Study.alpha = 1.0
            }
     
            else {
     
                location.alpha = 0.3
                submitButton.alpha = 0.3
                findLocationOnMap.alpha = 0.3
                enterLink.alpha = 0.3
                mapView.alpha = 0.5
                where2Study.alpha = 0.3
            }
     
        }

    
    }
