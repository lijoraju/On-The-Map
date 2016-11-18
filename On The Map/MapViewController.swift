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
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        reloadMapView()
    }
    
    func reloadMapView() {
        
        // Clear previous annotations
       // let allAnnotations = self.mapView.annotations
      //  self.mapView.removeAnnotation(allAnnotations as! MKAnnotation)
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
}
    
    
