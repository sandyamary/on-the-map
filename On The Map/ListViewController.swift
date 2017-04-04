//
//  ListViewController.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/31/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

// MARK: - ListViewController: UIViewController

class ListViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    // MARK: Properties
    
    var studentLocations = [StudentLocation]()
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

// MARK: - FavoritesViewController: UITableViewDelegate, UITableViewDataSource

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationTableViewCell"
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell?.textLabel!.text = "default"
        cell?.textLabel!.text = "🔯 " + studentLocation.firstName + " " + studentLocation.lastName
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = studentLocations[(indexPath as NSIndexPath).row].mediaURL
        let app = UIApplication.shared
        if let toOpen = urlString, let url = URL(string: toOpen) {
            print(url)
            app.open(url, options: [:], completionHandler: nil)
        } else {
            print("not a link")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

