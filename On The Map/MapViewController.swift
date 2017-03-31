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
    
    var studentLocations: [[String:AnyObject]]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations { (studentLocations, error) in
            if let locations = studentLocations {
                self.studentLocations = locations
                var annotations = [MKPointAnnotation]()
                for eachLocation in self.studentLocations {
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    
                    let lat = CLLocationDegrees(eachLocation["latitude"] as! Double)
                    let long = CLLocationDegrees(eachLocation["longitude"] as! Double)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = eachLocation["firstName"] as! String
                    let last = eachLocation["lastName"] as! String
                    let mediaURL = eachLocation["mediaURL"] as! String
                    
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
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            let url = URL(string: "http://www.google.com")!
            if let toOpen = view.annotation?.subtitle! {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }

}

