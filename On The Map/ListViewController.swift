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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    // MARK: Logout button action
    @IBAction func tapLogoutButton(_ sender: AnyObject) {
        self.setUIEnabled(false)
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
    
    // MARK: Refresh button action
    @IBAction func tapRefreshButton(_ sender: AnyObject) {
        self.setUIEnabled(false)
        Settings.sharedInstance.refreshButtonAction { (refresh, errorString) in
            if refresh {
                self.tableView.reloadData()
                self.setUIEnabled(true)
            }
            
            else {
                performUIUpdatesOnMain {
                    Alerts.sharedObject.showAlert(controller: self, title: "Failed To Refresh", message: errorString!)
                    self.setUIEnabled(true)
                }
        
            }
            
        }
        
    }
    
    // MARK: Pin button action
    @IBAction func tapPinButton(_ sender: AnyObject) {
        if thisUserPosted {
            showDoubleAlert(title: "Overwrite", message: "Would you like to overwrite your current location", identifier: "ListToPin")
        }
        
        else {
            performUIUpdatesOnMain {
                self.performSegue(withIdentifier: "ListToPin", sender: self)
            }
            
        }
        
    }
    
    // Returns the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsData.sharedInstance.mapPins.count
    }
    
    // Returns the table cell at the specified index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mapPoint = StudentsData.sharedInstance.mapPins[(indexPath as NSIndexPath).row]
        if mapPoint.name == UdacityLogin.sharedInstance.Name {
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
        
        // Deselect the selected row here so that the row doesn't remain in the selected state after opening the browser
        tableView.deselectRow(at: indexPath, animated: true)
        for result in StudentsData.sharedInstance.mapPins {
            urlArray.append(result.mediaURL)
        }
        
        let url = Browser.sharedInstance.cleanURL(url: urlArray[indexPath.row])
        Browser.sharedInstance.Open(Scheme: url)
    }
    
    // MARK: Configure UI
    func setUIEnabled(_ enabled: Bool) {
        if enabled {
            performUIUpdatesOnMain {
                self.table.alpha = 1.0
                self.logoutButton.isEnabled = true
                self.refreshButton.isEnabled = true
                self.pinButton.isEnabled = true
            }
           
        }
        
        else {
            performUIUpdatesOnMain {
                self.table.alpha = 0.6
                self.logoutButton.isEnabled = false
                self.refreshButton.isEnabled = false
                self.pinButton.isEnabled = false
            }
            
        }
        
    }
    
}
