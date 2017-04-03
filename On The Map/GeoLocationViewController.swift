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
    
    @IBOutlet var emptyMediaURLErrorLabel: UILabel!
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isUserInteractionEnabled = false
        submitButton.backgroundColor = UIColor.lightGray
        emptyMediaURLErrorLabel.isHidden = true
        
        enterUrlTextView.delegate = self
        enterUrlTextView.text = "Enter A Link To Share Here"
        enterUrlTextView.textColor = UIColor.lightGray
        enterUrlTextView.isEditable = true
        enterUrlTextView.backgroundColor = UIColor.init(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapString) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let annotation = MKPlacemark(placemark: placemarks.first!)
                    let coordinates = placemarks.first!.location
                    self.latitude = Double((coordinates?.coordinate.latitude)!)
                    self.longitude = Double((coordinates?.coordinate.longitude)!)
                    
                    let center = CLLocationCoordinate2D(latitude: coordinates!.coordinate.latitude, longitude: coordinates!.coordinate.longitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0))
                    performUIUpdatesOnMain {
                        self.postPinMapView.setRegion(region, animated: true)
                        self.postPinMapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
    @IBAction func submitStudentLocation(_ sender: UIButton) {
        
        getStudentInformation()
        
        //pass the information to parse api to post student location (uniquekey, fname, lname, mapstring, mediaurl, lat, lon
        ParseClient.sharedInstance().postStudentLocation(uniqueKey: self.studentUniqueKey, firstName: self.studentFirstname, lastName: self.studentLastname, mapString: self.mapString, mediaURL: self.enterUrlTextView.text, latitude: self.latitude, longitude: self.longitude) { (objectID, error) in
            
            if let _ = objectID {
                performUIUpdatesOnMain {
                    print("SUCCESS")
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getStudentInformation() {
        
        //get unique key from the Udacity post session
        studentUniqueKey = UdacityClient.sharedInstance().uniqueKey
        
        //get udacity user fname and lname using the unique key
        UdacityClient.sharedInstance().getUserData { (udacityStudentData, error) in
            
            if let udacityStudentData = udacityStudentData {
                self.studentFirstname = udacityStudentData.firstName
                self.studentLastname = udacityStudentData.lastName
            }
            
        }
    }
    
}


extension GeoLocationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        submitButton.isUserInteractionEnabled = true
        if textView.text == "Enter A Link To Share Here" {
            textView.text = ""
            textView.textColor = UIColor.white
        } else {
            textView.isEditable = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyMediaURLErrorLabel.isHidden = false
            submitButton.isUserInteractionEnabled = false
        } else {
            emptyMediaURLErrorLabel.isHidden = true
            LoginViewController.sharedInstance().customizeButtonsLook(button: submitButton)
            submitButton.isUserInteractionEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
