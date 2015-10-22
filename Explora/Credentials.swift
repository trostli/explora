//
//  Credentials.swift
//  Explora
//
//  Created by admin on 10/18/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit

struct Credentials {
    static let defaultCredentialsFile = "Credentials"
    static let defaultCredentials     = Credentials.loadFromPropertyListNamed(defaultCredentialsFile)
    
    let parseID: String
    let parseKey: String
    let mapboxKey: String
    
    private static func loadFromPropertyListNamed(name: String) -> Credentials {
        
        // You must add a Credentials.plist file
        let path           = NSBundle.mainBundle().pathForResource(name, ofType: "plist")!
        let dictionary     = NSDictionary(contentsOfFile: path)!
        let parseID    = dictionary["ParseID"] as! String
        let parseKey = dictionary["ParseClientKey"] as! String
        let mapboxKey = dictionary["MGLMapboxAccessToken"] as! String
        
        return Credentials(parseID: parseID, parseKey: parseKey, mapboxKey: mapboxKey)
    }
}