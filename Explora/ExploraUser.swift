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

import UIKit
import Parse

protocol ExploraUser {
    var createdEvents: [String]? { get }
    var participatingEvents: [String]? { get }
}

extension PFUser : ExploraUser {
    // username
    // email
    // password
    
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

}
