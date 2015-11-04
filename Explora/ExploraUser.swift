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
import FBSDKCoreKit

protocol ExploraUser {
    var createdEvents: [String]? { get }
    var participatingEvents: [String]? { get }
    var firstName: String? { get }
    var pictureURL: String? { get }
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
    
    var firstName: String? {
        get {
            return self["first_name"] as? String
        }
        set {
            self["first_name"] = newValue
        }
    }
    
    var pictureURL: String? {
        get {
            return self["picture_url"] as? String
        }
        set {
            self["picture_url"] = newValue
        }
    }

    func getUserInfo() {
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil) {
                    let dict = result as! NSDictionary
                    if let user = PFUser.currentUser() {
                        user.firstName = dict["first_name"] as? String
                        user.pictureURL = dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String
                        user.saveEventually()
                    }
                }
            })
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
