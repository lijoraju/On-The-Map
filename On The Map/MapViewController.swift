//
//  MapViewController.swift
//  On The Map
//
//  Created by LIJO RAJU on 16/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var thisUserPosted = false
    
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
        
        setUIEnabled(true)
    }
   
    // MARK: Tap on Pin Button
    @IBAction func tapPinButton(_ sender: AnyObject) {
        
        setUIEnabled(false)
        if thisUserPosted {
            
            showDoubleAlert(title: "Overwrite", message: "Would you like to overwrite your current location")
        }
            
        else {
            
            performUIUpdatesOnMain {
                
                self.setUIEnabled(true)
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
    
    // MARK: Refreshing Map View
    @IBAction func tapRefreshButton(_ sender: AnyObject) {
        
        setUIEnabled(false)
        Settings.sharedInstance().refreshButtonAction { (refresh) in
            
            if refresh {
                
                performUIUpdatesOnMain {
                    
                    self.reloadMapView()
                }

            }
            
        }
        
    }
    
    // MARK: Logout from Udacity API or Facebook API
    @IBAction func tapLogoutButton(_ sender: AnyObject) {
        
        setUIEnabled(false)
        Settings.sharedInstance().logoutButtonAction { (logout) in
            
            if logout {
                
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.dismiss(animated: true, completion: nil)
                }

            }
            
        }
        
    }
    
    // MARK: Overwrite alert
    func showDoubleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result: UIAlertAction)-> Void in
            
            self.setUIEnabled(true)
        }
        
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (result: UIAlertAction)-> Void in
            
            performUIUpdatesOnMain {
                
                self.setUIEnabled(true)
                self.performSegue(withIdentifier: "MapToPin", sender: self)
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(overwriteAction)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: Configure UI
    func setUIEnabled(_ enabled: Bool) {
        
        if enabled {
            
            activityIndicator.stopAnimating()
            mapView.alpha = 1.0
            logoutButton.isEnabled = true
            refreshButton.isEnabled = true
            pinButton.isEnabled = true
        }
        
        else {
            
            activityIndicator.startAnimating()
            mapView.alpha = 0.5
            logoutButton.isEnabled = false
            refreshButton.isEnabled = false
            pinButton.isEnabled = false
        }
        
    }
    
}

