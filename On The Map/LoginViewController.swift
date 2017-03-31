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
    
    
    @IBOutlet var usernameField: UITextField!

    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var debugTextLabel: UILabel!
    
    var session: URLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        self.authenticateWithViewController(self) { (success, errorString) in
 
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        UdacityClient.sharedInstance().postSession(username: "sandyamary.u@gmail.com", password: "soccerage") { (success, sessionID, errorString) in
            if success {
                if let sessionId = sessionID {
                    UdacityClient.sharedInstance().sessionID = sessionId
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
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }

    
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
