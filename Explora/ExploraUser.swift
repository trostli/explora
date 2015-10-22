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
    var createdEvents: [NSString]? { get }
    var participatingEvents: [NSString]? { get }
}

extension PFUser : ExploraUser {
    // username
    // email
    // password
    
    var createdEvents: [NSString]? {
        get {
            return self["created_events"] as? [NSString]
        }
        set {
            self["created_events"] = newValue
        }
    }
    
    var participatingEvents: [NSString]? {
        get {
            return self["participating_events"] as? [NSString]
        }
        set {
            self["participating_events"] = newValue
        }
    }
}
