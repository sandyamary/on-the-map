//
//  MapViewController.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/28/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var studentLocations: [StudentLocation]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPin))
        
        parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(logout))
        
        mapView.delegate = self
        
        ParseClient.sharedInstance().getStudentLocations { (studentLocations, error) in
            if let locations = studentLocations {
                self.studentLocations = locations
                var annotations = [MKPointAnnotation]()
                for eachLocation in self.studentLocations {
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    
                    let lat = CLLocationDegrees(eachLocation.latitude)
                    let long = CLLocationDegrees(eachLocation.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = eachLocation.firstName
                    let last = eachLocation.lastName
                    let mediaURL = eachLocation.mediaURL
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                
                self.mapView.addAnnotations(annotations)

            } else {
                print(error!)
            }
        }
    }
    
    // MARK: Add Location
    
    func addPin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PostLocationNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: Logout
    
    func logout() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
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
                    } else {
                        print("not a link")
                    }
                }
    }
    
    
    
}

