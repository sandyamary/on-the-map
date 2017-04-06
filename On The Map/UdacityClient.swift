//
//  UdacityClient.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/30/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation

// MARK: - UdacityClient: NSObject

class UdacityClient : NSObject {
    
    // MARK: Properties
    var sessionID: String? = nil
    var uniqueKey: String? = nil
    var userID: String? = nil
    
    // shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK: POST
    
    func taskForUdacityPOSTMethod(_ method: String, jsonBody: String, completionHandlerForUdacityPOST: @escaping (_ result: [String: AnyObject]?, _ errorString: String?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the common parameters */
        //None
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: buildURLFromParameters(withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                completionHandlerForUdacityPOST(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("Weak or No Connection")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Either the email or password is incorrect")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("Did not find your Account")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForUdacityPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: GET
    
    func taskForUdacityGETMethod(_ method: String, completionHandlerForUdacityGET: @escaping (_ result: [String: AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the common parameters */
        //None
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: self.buildURLFromParameters(withPathExtension: method))
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                completionHandlerForUdacityGET(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("Weak or No Connection")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Service response Issue")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No students available")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForUdacityGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }


    func taskForDeleteMethod(_ method: String, completionHandlerForDELETE: @escaping (_ result: [String: AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: self.buildURLFromParameters(withPathExtension: method))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                completionHandlerForDELETE(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("Weak or No Connection")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Service response Issue")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                //No data in response
                sendError("Session could not be deleted")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: [String: AnyObject]?, _ error: String?) -> Void) {
        
        let range = Range(5 ..< data.count)
        let newData = data.subdata(in: range)
        
        var parsedResult: [String: AnyObject]? = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String: AnyObject]
        } catch {
            //let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, "Service Error")
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    func buildURLFromParameters(withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}

