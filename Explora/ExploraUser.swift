//
//  ExploraUser.swift
//  Explora
//
//  Created by admin on 10/18/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//
/*
    User
    - username/email (already implemented by PFUser)
    - password (already implemented by PFUser)
    - facebook id?
    - array of event ids user has created
    - array of event ids user is participating in
*/

import Parse

protocol ExploraUser {
    var createdEvents: [String]? { get }
    var participatingEvents: [String]? { get }
}

extension PFUser : ExploraUser {
    // username
    // email
    // password
    
    @NSManaged var lastKnownLocation: PFGeoPoint?
    
    var createdEvents: [String]? {
        get {
            return self["created_events"] as? [String]
        }
        set {
            self["created_events"] = newValue
        }
    }
    
    var participatingEvents: [String]? {
        get {
            return self["participating_events"] as? [String]
        }
        set {
            self["participating_events"] = newValue
        }
    }
    
    // MARK: - Location
    
    // Synchronize the user's location with Parse
    func updateLocation() {
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                self.lastKnownLocation = geoPoint
                
                // Update Parse last known location for the current user
                PFUser.currentUser()?.setObject(geoPoint!, forKey: "lastKnownLocation")
                PFUser.currentUser()?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success {
                        print("lastKnownLocation successfully updated")
                    } else {
                        print("\(error)")
                    }
                }

            }
        }
    }


}
