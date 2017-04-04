//
//  LoginViewController.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/30/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var usernameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var debugTextLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    // MARK: Properties
    
    var session: URLSession!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        CustomizeButton.customizeButtonsLook(button: loginButton)
        configureBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        self.authenticateWithViewController(usernameField.text!, passwordField.text!, self) { (success, errorString) in
            
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    
    @IBAction func newUserSignUp(_ sender: Any) {
        let app = UIApplication.shared
        let toOpen = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
        if let url = URL(string: toOpen) {
            app.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: Authenticate
    
    func authenticateWithViewController(_ userName: String, _ passWord: String, _ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        UdacityClient.sharedInstance().postSession(username: userName, password: passWord) { (success, sessionID, key, errorString) in
            if success {
                if let sessionId = sessionID {
                    UdacityClient.sharedInstance().sessionID = sessionId
                    UdacityClient.sharedInstance().uniqueKey = key
                }
                completionHandlerForAuth(success, errorString)
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    
    // MARK: Login
    
    private func completeLogin() {
        debugTextLabel.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: Login Error
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
    
    // MARK: Configure UI Look
    
    func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
