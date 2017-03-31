//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/30/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
}
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "user_id"
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "/session"
        static let UserData = "users/{user_id}"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        
        // MARK: Student Locations
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
        
        // MARK: Udacity Student Data
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"

    }

}
