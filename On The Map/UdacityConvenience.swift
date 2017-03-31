//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/30/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    
    func postSession(username: String, password: String, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //none
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        /* 2. Make the request */
        let _ = taskForUdacityPOSTMethod(Methods.Session, jsonBody: jsonBody) { (results, error) in

            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForSession(false, nil, "Login Failed (Request Token).")
            } else {
                if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject], let sessionid = session[UdacityClient.JSONResponseKeys.Id] as? String {
                    completionHandlerForSession(true, sessionid, nil)
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(results)")
                    completionHandlerForSession(false, nil, "Login Failed (due to Request Token).")
                }
            }
        }
    }
    
    
    func deleteSession(completionHandlerForDeleteSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //none
        
        /* 2. Make the request */
        let _ = taskForDeleteMethod(Methods.Session, parameters: [String:AnyObject]()) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForDeleteSession(false, "Cannot delete Session ID.")
            } else {
                if let results = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] {
                    let sessionID = results[UdacityClient.JSONResponseKeys.Id] as? String
                    print("Deleted session id \(sessionID)")
                    completionHandlerForDeleteSession(true, nil)
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(results)")
                    completionHandlerForDeleteSession(false, "Cannot delete Session ID")
                }
            }
        }
    }
    
    func getUserData(username: String, password: String, completionHandlerForUserData: @escaping (_ result: UdacityStudent?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //none
        
        var mutableMethod: String = Methods.UserData
        mutableMethod = ParseClient.sharedInstance().substituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().userID!))!
        
        /* 2. Make the request */
        let _ = taskForUdacityGETMethod(mutableMethod, parameters: [String:AnyObject]()) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForUserData(nil, error)
            } else {
                if let results = results?[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] {
                    let udacityStudentData = UdacityStudent(dictionary: results)
                    completionHandlerForUserData(udacityStudentData, nil)
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.User) in \(results)")
                    completionHandlerForUserData(nil, error)
                }
            }
        }
    }
    
    
    
}
