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
    
    // MARK: Properties
    
    var updateLocation: Bool!
    
    // MARK: Outlets
    
    @IBOutlet var enterLocationTextView: UITextView!
    
    @IBOutlet var findOnMapButton: UIButton!
    
    @IBOutlet var emptyLocationErrorLabel: UILabel!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findOnMapButton.isUserInteractionEnabled = false
        findOnMapButton.backgroundColor = UIColor.lightGray
        emptyLocationErrorLabel.isHidden = true
        enterLocationTextView.delegate = self
        enterLocationTextView.text = "Enter Your Location Here"
        enterLocationTextView.textColor = UIColor.lightGray
        enterLocationTextView.isEditable = true
        enterLocationTextView.backgroundColor = UIColor.init(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0)
        
    }
    
    // MARK: Actions
    
    @IBAction func findOnMap(_ sender: UIButton) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GeoLocationViewController") as! GeoLocationViewController
        controller.mapString = enterLocationTextView.text
        controller.updateLocation = self.updateLocation
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}


// MARK: TextView Delegate methods

extension AddStudentLocationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        findOnMapButton.isUserInteractionEnabled = true
        if textView.text == "Enter Your Location Here" {
            textView.text = ""
            textView.textColor = UIColor.white
        } else {
            textView.isEditable = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            emptyLocationErrorLabel.isHidden = false
            findOnMapButton.isUserInteractionEnabled = false
        } else {
            emptyLocationErrorLabel.isHidden = true
            CustomizeButton.customizeButtonsLook(button: findOnMapButton)
            findOnMapButton.isUserInteractionEnabled = true
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
