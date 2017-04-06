//
//  StudentInformation.swift
//  On The Map
//
//  Created by Udumala, Mary on 4/5/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

class StudentInformation {
    
    var studentLocations = [StudentLocation]()
    
    class func sharedInstance() -> StudentInformation {
        struct Singleton {
            static var sharedInstance = StudentInformation()
        }
        return Singleton.sharedInstance
    }
    
}


