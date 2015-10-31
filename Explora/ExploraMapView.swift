//
//  ExploraMapView.swift
//  Explora
//
//  Created by Daniel Trostli on 10/28/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Mapbox

class ExploraMapView: MGLMapView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func addEventToMap(event: ExploraEvent){
        if event.eventLocation != nil {
            let pin = ExploraPointAnnotation.init(event: event)
            self.addAnnotation(pin)
        }
    }

}
