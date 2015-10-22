//
//  DiscoveryViewController.swift
//  Explora
//
//  Created by Daniel Trostli on 10/20/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Mapbox
import Parse

class DiscoveryViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    var userLocation: PFGeoPoint?
    var events: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize the map view
        let styleURL = NSURL(string: "asset://styles/light-v8.json")
        mapView = MGLMapView(frame: view.bounds, styleURL: styleURL)
        mapView.showsUserLocation = true
        mapView.delegate = self

        getCurrentLocation()
        view.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEvents() {
        var query = PFQuery(className:"ExploraEvent")
        query.whereKey("location", nearGeoPoint:userLocation!)
        query.limit = 10
        // Final list of objects
        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                self.events = objects
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                self.addEventsToMap()
                if let objects = objects as? [PFObject]! {
                    for object in objects {
                        print(object.objectId)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        })
    }
    
    func addEventsToMap() {
        if let events = events as? [PFObject]! {
            for event in events {
                addEventToMap(event)
            }
        }
    }
    
    func addEventToMap(event: PFObject){
        if event["location"] != nil {
            let pin = MGLPointAnnotation()
            let geoPoint = event["location"] as! PFGeoPoint
            let coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)
            pin.coordinate = coordinate
            pin.title = "PARTY"
            pin.subtitle = "Lets grab some drinks guys"
            
            self.mapView.addAnnotation(pin)
        }
    }
    
    // Should be move outside of controller to user model
    func getCurrentLocation() {
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                self.userLocation = geoPoint
                let coordinate = CLLocationCoordinate2DMake(geoPoint!.latitude, geoPoint!.longitude)
                
                self.mapView.setCenterCoordinate(coordinate, zoomLevel: 12.0, animated: true)
                
                var event = PFObject(className:"ExploraEvent")
                event["location"] = geoPoint
                event.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.getEvents()

                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                }
            }
        }
    }
    
    // MARK: - Mapbox delegate
    
    // Use the default marker; see our custom marker example for more information
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("people")
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project
            let image = UIImage(named: "people")
            annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: "people")
        }

        return annotationImage
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        print("callout")
        self.performSegueWithIdentifier("detailSegue", sender: self)
    }
    
    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        let arrowButton = UIButton.init(type: UIButtonType.System) as UIButton
        arrowButton.frame = CGRectMake(50, 50, 50, 50)

        let arrowImage = UIImage.init(named: "arrow") as UIImage?
        arrowButton.setImage(arrowImage, forState: UIControlState.Normal)

        return arrowButton
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
