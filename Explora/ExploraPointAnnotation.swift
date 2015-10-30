//
//  ExploraPointAnnotation.swift
//  Explora
//
//  Created by Daniel Trostli on 10/21/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Mapbox

class ExploraPointAnnotation: MGLPointAnnotation {
    
    var event: ExploraEvent?
    
    convenience init(event: ExploraEvent) {
        self.init()
        
        self.event = event
        
        if event.eventLocation != nil {
            self.coordinate = event.eventCoordinate!
        }
        
        if event.eventTitle != nil {
            self.title = event.eventTitle!
        } else {
            self.title = "(no title)"
        }
        
        if event.eventDescription != nil {
            self.subtitle = event.eventDescription!
        }
    }
    
}
