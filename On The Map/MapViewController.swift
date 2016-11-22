//
//  MapViewController.swift
//  On The Map
//
//  Created by LIJO RAJU on 16/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var thisUserPosted = false
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        reloadMapView()
    }
    
    func reloadMapView() {
        
        //remove all previous annotations
        let allAnnotations = self.mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        
        for result in StudentsData.sharedInstance().mapPins {
            
            // Create annotation
            let annotation = MKPointAnnotation()
            
            // Set the coordinate and add it to annotation
            let location = CLLocationCoordinate2D(latitude: result.Latitude, longitude: result.Longitude)
            annotation.coordinate = location
            
            // Add student name and mediaURL for annotation
            annotation.title = result.Name
            annotation.subtitle = result.mediaURL
            
            // Add annotation to map
            mapView.addAnnotation(annotation)
            
            // Check whether this user already posted
            if result.Name == UdacityLogin.sharedInstance().Name {
                
                thisUserPosted = true
            }
            
            }
        
    }
   
    // MARK: Tap on Pin Button
    @IBAction func tapPinButton(_ sender: AnyObject) {
        
        if thisUserPosted {
            
        showDoubleAlert(title: "Overwrite", message: "Would you like to overwrite your current location")
        }
        
        else {
            
           performUIUpdatesOnMain {
                
                self.performSegue(withIdentifier: "MapToPin", sender: self)
            }

        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let View = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        View.canShowCallout = true
        View.calloutOffset = CGPoint(x: -5, y: -5)
        View.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        return View
    }
 
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let url = Browser.sharedInstance().cleanURL(url: view.annotation!.subtitle!!)
        Browser.sharedInstance().Open(Scheme: url)
    }
    
    // MARK: Double button alert
    func showDoubleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (result: UIAlertAction)-> Void in
            
            performUIUpdatesOnMain {
                
                self.performSegue(withIdentifier: "MapToPin", sender: self)
            }
            
        }
            alert.addAction(cancelAction)
            alert.addAction(overwriteAction)
            self.present(alert, animated: true, completion: nil)
    }

    // MARK: Refreshing Map View
    @IBAction func refreshMap(_ sender: AnyObject) {
        
        // Fetching students infomation from parse API
        studentLocation.sharedInstance().gettingStudentLocations{ (sucess,error) in
            
            if error != nil {
                
                performUIUpdatesOnMain {
                    
                    Alerts.sharedObject.showAlert(controller: self, title: "Error Refreshing Map", message: error!)
                }
                
            }
                
            else {
                
                performUIUpdatesOnMain {
                    
                    self.reloadMapView()
                }
                
            }
            
        }

    }
    
    // MARK: Logout from Udacity API or Facebook API
    @IBAction func logout(_ sender: AnyObject) {
        
        UdacityLogin.sharedInstance().logoutFromUdacity { (sucess,error) in
            
            if sucess {
                
                performUIUpdatesOnMain {
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
            else {
                
                Alerts.sharedObject.showAlert(controller: self, title: "Logout Failed", message: error!)
            }
            
        }

    }

}

