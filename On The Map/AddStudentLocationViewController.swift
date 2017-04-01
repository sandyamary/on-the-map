//
//  AddStudentLocationViewController.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/31/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit

class AddStudentLocationViewController: UIViewController {
    
    
    @IBOutlet var enterLocationTextView: UITextView!
    @IBOutlet var findOnMapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterLocationTextView.delegate = self
        enterLocationTextView.text = "Enter Your Location Here"
        enterLocationTextView.textColor = UIColor.lightGray
        enterLocationTextView.isEditable = true
        LoginViewController.sharedInstance().customizeButtonsLook(button: findOnMapButton)
        
    }
    
    @IBAction func findOnMap(_ sender: UIButton) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "GeoNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

    
    

    
    
    
    

//func addPin() {
//    ParseClient.sharedInstance().postStudentLocation(uniqueKey: "", firstName: <#T##String#>, lastName: <#T##String#>, mapString: <#T##String#>, mediaURL: <#T##String#>, latitude: <#T##Double#>, longitude: <#T##Double#>) { (objectID, error) in
//        if success {
//            if let sessionId = sessionID {
//                UdacityClient.sharedInstance().sessionID = sessionId
//            }
//            completionHandlerForAuth(success, errorString)
//        } else {
//            completionHandlerForAuth(success, errorString)
//        }
//    }
//}



extension AddStudentLocationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter Your Location Here" {
            textView.text = ""
            textView.textColor = UIColor.white
        } else {
            textView.isEditable = true
        }
    }
}