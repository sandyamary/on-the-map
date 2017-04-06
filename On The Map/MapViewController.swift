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
    var loggedUserObjectID: String!
    let studentInformationInstance = StudentInformation.sharedInstance()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "MarkerIcon")!, style: .plain, target: self, action: #selector(addLocation))
        
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations { (studentLocations, error) in
            if let locations = studentLocations  {
                var annotations = [MKPointAnnotation]()
                for eachLocation in locations {
                    self.studentInformationInstance.studentLocations.append(eachLocation)
                    
                    if let lat = eachLocation.latitude, let lon = eachLocation.longitude {
                        
                        if UdacityClient.sharedInstance().uniqueKey == eachLocation.studentUniqueKey {
                            ParseClient.sharedInstance().objectID = eachLocation.objectID
                        }
                        
                        let lat = CLLocationDegrees(lat)
                        let long = CLLocationDegrees(lon)
                        
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
                }
                
                performUIUpdatesOnMain {
                    self.mapView.addAnnotations(annotations)
                }
                
            } else {
                Common.showUserAlert(messageTitle: "Oops!", message: "Did not find any Udacity student locations", actionTitle: nil, cancelActionTitle: "Ok", hostViewController: self) { return }
            }
        }
    }
    
    
    
    // MARK: Add Location
    
    func addLocation() {
        
        if doesLocationExist() {
            
            Common.showUserAlert(messageTitle: "Alert", message: "You have already posted a student location. Would you like to overwrite it?", actionTitle: "Overwrite", cancelActionTitle: "Cancel", hostViewController: self ) {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddStudentLocationViewController") as! AddStudentLocationViewController
                controller.updateLocation = true
                self.present(controller, animated: true, completion: nil)
            }
            
        } else {
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddStudentLocationViewController") as! AddStudentLocationViewController
            controller.updateLocation = false
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    func doesLocationExist() -> Bool {
        for eachStudentLocation in self.studentInformationInstance.studentLocations {
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
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print(errorMessage ?? "Session could not be Deleted")
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
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
            if let annotation = view.annotation, let str = annotation.subtitle, let toOpen = str, let url = URL(string: toOpen) {
                if app.canOpenURL(url) {
                    app.open(url, options: [:], completionHandler: nil)
                    }
                    else {
                    Common.showUserAlert(messageTitle: "Not a Link", message: "Student did not post a url Link", actionTitle: nil, cancelActionTitle: "Ok", hostViewController: self) { return }
                }
            }
        }
    }
    
}

