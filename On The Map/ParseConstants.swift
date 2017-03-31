//
//  ParseConstants.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/29/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

// MARK: - ParseClient (Constants)

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let objectID = "objectId"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Student Locations
        static let StudentLocations = "/StudentLocation"
        static let UpdateStudentLocation = "/StudentLocation/{objectId}"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let UpdatedAt = "updatedAt"
    }
    
    // MARK: JSON Body Keys (for POST)
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let CreatedAt = "createdAt"
        static let ObjectID = "objectId"
        static let Results = "results"

        
        // MARK: Student Locations
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let UpdatedAt = "updatedAt"
        
    }
}
