//
//  TableViewController.swift
//  On The Map
//
//  Created by Udumala, Mary on 4/4/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

// MARK: - TableViewController: UITableViewController

class TableViewController: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    // MARK: Properties
    
    var studentLocations = [StudentLocation]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationsTableView.delegate = self
        self.locationsTableView.dataSource = self
        ParseClient.sharedInstance().getStudentLocations { (studentLocations, error) in
            if let locations = studentLocations {
                self.studentLocations = locations
                performUIUpdatesOnMain {
                    self.locationsTableView.reloadData()
                }
            } else {
                print(error!)
            }
            
        }
        
    }
}

// MARK: - TableViewController: UITableViewDelegate, UITableViewDataSource

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationTableViewCell"
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        
        /* Set cell defaults */
        cell.textLabel!.text = "✴️ \(studentLocation.firstName) \(studentLocation.lastName)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = studentLocations[(indexPath as NSIndexPath).row].mediaURL
        let app = UIApplication.shared
        if let toOpen = urlString, let url = URL(string: toOpen) {
            app.open(url, options: [:], completionHandler: nil)
        } else {
            print("not a link")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


