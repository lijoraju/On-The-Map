//
//  ListViewController.swift
//  On The Map
//
//  Created by LIJO RAJU on 23/11/16.
//  Copyright © 2016 LIJORAJU. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    var thisUserPosted = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    // MARK: Logout button action
    @IBAction func tapLogoutButton(_ sender: AnyObject) {
        
        Settings.sharedInstance().logoutButtonAction { (logout) in
            
            if logout {
                
                performUIUpdatesOnMain {
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    // MARK: Refresh button action
    @IBAction func tapRefreshButton(_ sender: AnyObject) {
        
        Settings.sharedInstance().refreshButtonAction { (refresh) in
            
            if refresh {
                
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    // MARK: Pin button action
    @IBAction func tapPinButton(_ sender: AnyObject) {
        
        if thisUserPosted {
            
            showDoubleAlert(title: "Overwrite", message: "Would you like to overwrite your current location")
        }
        
        else {
            
            performUIUpdatesOnMain {
                
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
        if mapPoint.Name == UdacityLogin.sharedInstance().Name {
            
            thisUserPosted = true
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.imageView?.image = UIImage(named: "Pin")
        cell.textLabel?.text = mapPoint.Name
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (result: UIAlertAction)-> Void in
            
            performUIUpdatesOnMain {
                
                self.performSegue(withIdentifier: "ListToMap", sender: self)
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(overwriteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
