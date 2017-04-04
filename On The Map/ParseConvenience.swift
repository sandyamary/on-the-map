//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/29/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit
import Foundation

// MARK: - ParseClient (Convenient Resource Methods)

extension ParseClient {
    
    func getStudentLocations(completionHandlerForStudentLocations: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //None
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.StudentLocations, parameters: [String:AnyObject]()) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocations(nil, error)
            } else {
                
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    let studentLocations = StudentLocation.studentLocationsFromResults(results)
                    completionHandlerForStudentLocations(studentLocations, nil)
                } else {
                    completionHandlerForStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
        
    }
    
    
    
    // MARK: POST Convenience Method
    
    func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForStudentLocation: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //none

        let jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(uniqueKey)\",\"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(firstName)\",\"\(ParseClient.JSONBodyKeys.LastName)\": \"\(lastName)\", \"\(ParseClient.JSONBodyKeys.MapString)\": \"\(mapString)\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(mediaURL)\", \"\(ParseClient.JSONBodyKeys.Longitude)\": \(longitude), \"\(ParseClient.JSONBodyKeys.Latitude)\": \(latitude)}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(Methods.StudentLocations, parameters: [String:AnyObject](), jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocation(nil, error)
            } else {
                if let objectid = results?[ParseClient.JSONResponseKeys.ObjectID] as? String {
                    completionHandlerForStudentLocation(objectid, nil)
                } else {
                    completionHandlerForStudentLocation(nil, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
                }
            }
        }
    }
    
    
    func updateStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForStudentLocation: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        
        var mutableMethod: String = Methods.UpdateStudentLocation
        mutableMethod = substituteKeyInMethod(mutableMethod, key: ParseClient.URLKeys.objectID, value: String(ParseClient.sharedInstance().objectID!))!
        
        let jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(uniqueKey)\",\"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(firstName)\",\"\(ParseClient.JSONBodyKeys.LastName)\": \"\(lastName)\", \"\(ParseClient.JSONBodyKeys.MapString)\": \"\(mapString)\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(mediaURL)\", \"\(ParseClient.JSONBodyKeys.Longitude)\": \(longitude), \"\(ParseClient.JSONBodyKeys.Latitude)\": \(latitude)}"
        
        /* 2. Make the request */
        let _ = taskForPUTMethod(mutableMethod, parameters: [String:AnyObject](), jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocation(nil, error)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.UpdatedAt] as? String {
                    completionHandlerForStudentLocation(results, nil)
                } else {
                    completionHandlerForStudentLocation(nil, NSError(domain: "putStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse putStudentLocation"]))
                }
            }
        }
    }
    
}



