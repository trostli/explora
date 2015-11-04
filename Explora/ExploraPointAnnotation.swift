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
    
    func exploraPointAnnotation(imageForEventCategory mapView: MGLMapView) -> MGLAnnotationImage? {
        var annotationImage: MGLAnnotationImage?
        if let category = self.event?.category {
            switch category {
            case ExploraEventCategory.CommunityCulture.rawValue:
                annotationImage = dequeueReusableAnnotationImage(mapView, identifier: "people")
                break
            case ExploraEventCategory.FamilyEducation.rawValue:
                annotationImage = dequeueReusableAnnotationImage(mapView, identifier: "education")
                break
            case ExploraEventCategory.FoodDrink.rawValue:
                annotationImage = dequeueReusableAnnotationImage(mapView, identifier: "food_drink")
                break
            case ExploraEventCategory.FilmEntertainment.rawValue:
                annotationImage = dequeueReusableAnnotationImage(mapView, identifier: "film")
                break
            case ExploraEventCategory.HealthWellness.rawValue:
                annotationImage = dequeueReusableAnnotationImage(mapView, identifier: "health")
                break
            case ExploraEventCategory.Music.rawValue:
                annotationImage = dequeueReusableAnnotationImage(mapView, identifier: "music")
                break
            case ExploraEventCategory.PerformingVisualArts.rawValue:
                annotationImage = dequeueReusableAnnotationImage(mapView, identifier: "performing_arts")
                break
            case ExploraEventCategory.Sports.rawValue:
                annotationImage = dequeueReusableAnnotationImage(mapView, identifier: "sports")
                break
            case ExploraEventCategory.Travel.rawValue:
                annotationImage = dequeueReusableAnnotationImage(mapView, identifier: "outdoor")
                break
            default:
                break
            }
        }
        return annotationImage
    }
    
    private func dequeueReusableAnnotationImage(mapView: MGLMapView,identifier: String) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(identifier)
        if annotationImage == nil {
            let image = UIImage(named: identifier)
            annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: identifier)
        }
        return annotationImage
    }
}
