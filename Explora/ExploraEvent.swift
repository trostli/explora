//
//  ExploraEvent.swift
//  Explora
//
//  Created by admin on 10/18/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//
/*
    Events
    - creator id
    - attendees array of ids
    - attendees limit?
    - title
    - description/tagline
    - event location
    - meeting location
    - meeting start time
    - meeting end time?
    - event category
*/

import Parse

enum ExploraEventCategory: Int {
    case Other = 0, CommunityCulture, FamilyEducation, FoodDrink, FilmEntertainment, HealthWellness, Music, PerformingVisualArts, Sports, Travel
}

struct ExploraEventCategories {
    static let categories: [[ExploraEventCategory : String]] = [
        [.Other : "Other"],
        [.CommunityCulture : "Community & Culture"],
        [.FamilyEducation : "Family & Education"],
        [.FoodDrink : "Food & Drink"],
        [.FilmEntertainment : "Film, Media & Entertainment"],
        [.HealthWellness : "Health & Wellness"],
        [.Music : "Music"],
        [.PerformingVisualArts : "Performing & Visual Arts"],
        [.Sports : "Sports & Fitness"],
        [.Travel : "Travel & Outdoor"]
    ]
}

class ExploraEvent: PFObject, PFSubclassing {
    
    var creatorID: String? {
        get {
            return self["creator_id"] as? String
        }
        set {
            self["creator_id"] = newValue
        }
    }
    
    var attendees: [String]? {
        get {
            return self["attendees"] as? [String]
        }
        set {
            self["attendees"] = newValue
        }
    }
    
    var attendeesLimit: Int? {
        get {
            return self["attendees_limit"] as? Int
        }
        set {
            self["attendees_limit"] = newValue
        }
    }
    
    var eventTitle: String? {
        get {
            return self["event_title"] as? String
        }
        set {
            self["event_title"] = newValue
        }
    }
    
    var eventDescription: String? {
        get {
            return self["event_description"] as? String
        }
        set {
            self["event_description"] = newValue
        }
    }
    
    var eventLocation: PFGeoPoint? {
        get {
            return self["event_location"] as? PFGeoPoint
        }
        set {
            self["event_location"] = newValue
        }
    }
    
    var eventCoordinate: CLLocationCoordinate2D? {
        if eventLocation != nil {
            return CLLocationCoordinate2DMake(eventLocation!.latitude, eventLocation!.longitude)
        } else {
            return nil
        }
    }
    
    var meetingLocationLat: CLLocationDegrees? {
        get {
            return self["meeting_location_lat"] as? CLLocationDegrees
        }
        set {
            self["meeting_location_lat"] = newValue
        }
    }

    var meetingLocationLng: CLLocationDegrees? {
        get {
            return self["meeting_location_lng"] as? CLLocationDegrees
        }
        set {
            self["meeting_location_lng"] = newValue
        }
    }
    
    var meetingStartTime: NSDate? {
        get {
            return self["meeting_start_time"] as? NSDate
        }
        set {
            self["meeting_start_time"] = newValue
        }
    }
    
    var meetingEndTime: NSDate? {
        get {
            return self["meeting_end_time"] as? NSDate
        }
        set {
            self["meeting_end_time"] = newValue
        }
    }
    
    var category: Int? {
        get {
            return self["category"] as? Int
        }
        set {
            self["category"] = newValue
        }
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }

    static func parseClassName() -> String {
        return "ExploraEvent"
    }
}
