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

class ExploraEvent: PFObject, PFSubclassing {
    
    var creatorID: NSString? {
        get {
            return self["creator_id"] as? NSString
        }
        set {
            self["creator_id"] = newValue
        }
    }
    
    var eventTitle: NSString? {
        get {
            return self["event_title"] as? NSString
        }
        set {
            self["event_title"] = newValue
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
