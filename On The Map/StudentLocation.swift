//
//  StudentLocation.swift
//  On The Map
//
//  Created by Udumala, Mary on 3/29/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

// MARK: - StudentLocation

struct StudentLocation {
    
    // MARK: Properties
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let objectID: String
    let mediaURL: String?
    let studentUniqueKey: String

    
    // MARK: Initializers
    
    // construct a TMDBMovie from a dictionary
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        studentUniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        objectID = dictionary[ParseClient.JSONResponseKeys.ObjectID] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        if let mediaLink = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String, mediaLink.isEmpty == false {
            mediaURL = mediaLink
        } else {
            mediaURL = ""
        }
    }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        
        // iterate through array of dictionaries, each studentlocation is a dictionary
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
}

// MARK: - TMDBMovie: Equatable

extension StudentLocation: Equatable {}

func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
    return lhs.objectID == rhs.objectID
}

