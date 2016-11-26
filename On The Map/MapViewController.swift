//
//  MapViewController.swift
//  On The Map
//
//  Created by LIJO RAJU on 16/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import UIKit
import MapKit

var thisUserPosted = false

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        reloadMapView()
    }
    
    func reloadMapView() {
        
        //remove all previous annotations
        let allAnnotations = self.mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        for result in StudentsData.sharedInstance.mapPins {
            
            // Create annotation
            let annotation = MKPointAnnotation()
            
            // Set the coordinate and add it to annotation
            let location = CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude)
            annotation.coordinate = location
            
            // Add student name and mediaURL for annotation
            annotation.title = result.name
            annotation.subtitle = result.mediaURL
            
            // Add annotation to map
            mapView.addAnnotation(annotation)
            
            // Check whether this user already posted
            if result.name == UdacityLogin.sharedInstance.Name {
                thisUserPosted = true
            }
            
            }
        
        setUIEnabled(true)
    }
   
    // MARK: Tap on Pin Button
    @IBAction func tapPinButton(_ sender: AnyObject) {
        if thisUserPosted {
            showDoubleAlert(title: "Overwrite", message: "Would you like to overwrite your current location", identifier: "MapToPin")
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
        let url = Browser.sharedInstance.cleanURL(url: view.annotation!.subtitle!!)
        Browser.sharedInstance.Open(Scheme: url)
    }
    
    // MARK: Refreshing Map View
    @IBAction func tapRefreshButton(_ sender: AnyObject) {
        setUIEnabled(false)
        Settings.sharedInstance.refreshButtonAction { (refresh, errorString) in
            if refresh {
                performUIUpdatesOnMain {
                    self.reloadMapView()
                }

            }
            
            else {
                performUIUpdatesOnMain {
                    Alerts.sharedObject.showAlert(controller: self, title: "Failed To Refresh", message: errorString!)
                    self.setUIEnabled(true)
                }
                
            }
            
        }
        
    }
    
    // MARK: Logout from Udacity API or Facebook API
    @IBAction func tapLogoutButton(_ sender: AnyObject) {
        setUIEnabled(false)
        Settings.sharedInstance.logoutButtonAction { (logout, errorString) in
            if logout {
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        
                else {
                    performUIUpdatesOnMain {
                        Alerts.sharedObject.showAlert(controller: self, title: "Logout Failed", message: errorString!)
                        self.setUIEnabled(true)
                    }
                
            }
            
        }
        
    }
    
    // MARK: Configure UI
    func setUIEnabled(_ enabled: Bool) {
        if enabled {
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.mapView.alpha = 1.0
                self.logoutButton.isEnabled = true
                self.refreshButton.isEnabled = true
                self.pinButton.isEnabled = true
            }
            
        }
        
        else {
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
                self.mapView.alpha = 0.5
                self.logoutButton.isEnabled = false
                self.refreshButton.isEnabled = false
                self.pinButton.isEnabled = false
            }
            
        }
        
    }
    
}

