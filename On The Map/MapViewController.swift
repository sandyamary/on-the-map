//
//  MapViewController.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/28/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var mapView: MKMapView!
    
    
    // MARK: Properties
    
    var studentLocations: [StudentLocation]!
    var loggedUserObjectID: String!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "MarkerIcon")!, style: .plain, target: self, action: #selector(addLocation))
        
        parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations { (studentLocations, error) in
            if let locations = studentLocations {
                self.studentLocations = locations
                var annotations = [MKPointAnnotation]()
                for eachLocation in self.studentLocations {
                    
                    if UdacityClient.sharedInstance().uniqueKey == eachLocation.studentUniqueKey {
                        ParseClient.sharedInstance().objectID = eachLocation.objectID
                    }
                    
                    let lat = CLLocationDegrees(eachLocation.latitude)
                    let long = CLLocationDegrees(eachLocation.longitude)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = eachLocation.firstName
                    let last = eachLocation.lastName
                    let mediaURL = eachLocation.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                }
                
                performUIUpdatesOnMain {
                    self.mapView.addAnnotations(annotations)
                }
                
            } else {
                print(error!)
            }
        }
    }
    
    
    
    // MARK: Add Location
    
    func addLocation() {
        
        if doesLocationExist() {
            
            let alertController = UIAlertController(title: "Alert", message: "You have already posted a student location. Would you like to overwrite it?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                //set a flag to update location instead of posting new one
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddStudentLocationViewController") as! AddStudentLocationViewController
                controller.updateLocation = true
                self.present(controller, animated: true, completion: nil)
                
            }
            alertController.addAction(overwriteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddStudentLocationViewController") as! AddStudentLocationViewController
            controller.updateLocation = false
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    func doesLocationExist() -> Bool {
        for eachStudentLocation in studentLocations {
            if UdacityClient.sharedInstance().uniqueKey == eachStudentLocation.studentUniqueKey {
                return true
            }
        }
        return false
    }
    
    
    
    // MARK: Logout
    
    func logout() {
        UdacityClient.sharedInstance().deleteSession { (success, errorMessage) in
            if success {
                performUIUpdatesOnMain {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.present(controller, animated: true, completion: nil)
                }
            } else {
                print(errorMessage ?? "Session could not be Deleted")
                performUIUpdatesOnMain {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen) {
                print(url)
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}

