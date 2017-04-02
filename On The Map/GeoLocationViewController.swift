//
//  GeoLocationViewController.swift
//  On The Map
//
//  Created by Udumala, Mary on 4/1/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class GeoLocationViewController: UIViewController {
    
    var mapString: String!
    var studentUniqueKey: String!
    var latitude: Double!
    var longitude: Double!
    var studentFirstname: String!
    var studentLastname: String!
    
    @IBOutlet var enterUrlTextView: UITextView!
    
    @IBOutlet var postPinMapView: MKMapView!
    
    @IBOutlet var submitButton: UIButton!
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        enterUrlTextView.delegate = self
        enterUrlTextView.text = "Enter A Link To Share Here"
        enterUrlTextView.textColor = UIColor.lightGray
        enterUrlTextView.isEditable = true
        enterUrlTextView.backgroundColor = UIColor.init(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        LoginViewController.sharedInstance().customizeButtonsLook(button: submitButton)

        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapString) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let annotation = MKPlacemark(placemark: placemarks.first!)
                    let coordinates = placemarks.first!.location
                    self.latitude = Double((coordinates?.coordinate.latitude)!)
                    self.longitude = Double((coordinates?.coordinate.longitude)!)
                    self.postPinMapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    @IBAction func submitStudentLocation(_ sender: UIButton) {
        
        //get unique key from the Udacity post session
        studentUniqueKey = UdacityClient.sharedInstance().uniqueKey
        
        //get udacity user fname and lname using the unique key
        UdacityClient.sharedInstance().getUserData { (udacityStudentData, error) in
            
                if let udacityStudentData = udacityStudentData {
                    self.studentFirstname = udacityStudentData.firstName
                    self.studentLastname = udacityStudentData.lastName
        }

        
        //pass the information to parse api to post student location (uniquekey, fname, lname, mapstring, mediaurl, lat, lon
            ParseClient.sharedInstance().postStudentLocation(uniqueKey: self.studentUniqueKey, firstName: self.studentFirstname, lastName: self.studentLastname, mapString: self.mapString, mediaURL: self.enterUrlTextView.text, latitude: self.latitude, longitude: self.longitude) { (objectID, error) in
                
                if let _ = objectID {
                    print("SUCCESS")
                }
            }
    }
    
}
}




extension GeoLocationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter A Link To Share Here" {
            textView.text = ""
            textView.textColor = UIColor.white
        } else {
            textView.isEditable = true
        }
    }
}
