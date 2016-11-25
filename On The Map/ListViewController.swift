//
//  ListViewController.swift
//  On The Map
//
//  Created by LIJO RAJU on 23/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var thisUserPosted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    // MARK: Logout button action
    @IBAction func tapLogoutButton(_ sender: AnyObject) {
        self.setUIEnabled(false)
        Settings.sharedInstance().logoutButtonAction { (logout) in
            if logout {
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    // MARK: Refresh button action
    @IBAction func tapRefreshButton(_ sender: AnyObject) {
        self.setUIEnabled(false)
        Settings.sharedInstance().refreshButtonAction { (refresh, errorString) in
            if refresh {
                self.tableView.reloadData()
                self.setUIEnabled(true)
            }
            
            else {
                self.setUIEnabled(true)
                performUIUpdatesOnMain {
                    Alerts.sharedObject.showAlert(controller: self, title: "Failed To Refresh", message: errorString!)
                }
        
            }
            
        }
        
    }
    
    // MARK: Pin button action
    @IBAction func tapPinButton(_ sender: AnyObject) {
        self.setUIEnabled(false)
        if thisUserPosted {
            showDoubleAlert(title: "Overwrite", message: "Would you like to overwrite your current location")
        }
        
        else {
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                self.performSegue(withIdentifier: "ListToPin", sender: self)
            }
            
        }
        
    }
    
    // Returns the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return StudentsData.sharedInstance().mapPins.count
    }
    
    // Returns the table cell at the specified index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mapPoint = StudentsData.sharedInstance().mapPins[(indexPath as NSIndexPath).row]
        if mapPoint.name == UdacityLogin.sharedInstance().Name {
            thisUserPosted = true
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.imageView?.image = UIImage(named: "Pin")
        cell.textLabel?.text = mapPoint.name
        
        return cell
    }
    
    // Open Url when Row Selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlArray: [String] = []
        for result in StudentsData.sharedInstance().mapPins {
            urlArray.append(result.mediaURL)
        }
        
        let url = Browser.sharedInstance().cleanURL(url: urlArray[indexPath.row])
        Browser.sharedInstance().Open(Scheme: url)
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
                self.performSegue(withIdentifier: "ListToMap", sender: self)
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(overwriteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Configure UI
    func setUIEnabled(_ enabled: Bool) {
        if enabled {
            table.alpha = 1.0
            activityIndicator.stopAnimating()
            logoutButton.isEnabled = true
            refreshButton.isEnabled = true
            pinButton.isEnabled = true
        }
        
        else {
            table.alpha = 0.5
            activityIndicator.startAnimating()
            logoutButton.isEnabled = false
            refreshButton.isEnabled = false
            pinButton.isEnabled = false
        }
        
    }
    
}
