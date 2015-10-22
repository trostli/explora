//
//  Credentials.swift
//  Explora
//
//  Created by admin on 10/18/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit

struct ParseCredentials {
    static let defaultCredentialsFile = "Credentials"
    static let defaultCredentials     = ParseCredentials.loadFromPropertyListNamed(defaultCredentialsFile)
    
    let parseID: String
    let parseKey: String
    
    private static func loadFromPropertyListNamed(name: String) -> ParseCredentials {
        
        // You must add a Credentials.plist file
        let path           = NSBundle.mainBundle().pathForResource(name, ofType: "plist")!
        let dictionary     = NSDictionary(contentsOfFile: path)!
        let parseID    = dictionary["ParseID"] as! String
        let parseKey = dictionary["ParseClientKey"] as! String
        
        return ParseCredentials(parseID: parseID, parseKey: parseKey)
    }
}