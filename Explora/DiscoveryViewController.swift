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
    var events: [ExploraEvent]?
    
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize the map view
        let styleURL = NSURL(string: "asset://styles/light-v8.json")
        mapView = MGLMapView(frame: view.bounds, styleURL: styleURL)
        mapView.showsUserLocation = true
        mapView.delegate = self
        

        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)

        showCurrentLocationAndEvents()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        locationButton.layer.cornerRadius = 25
        locationButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLocationTap(sender: UIButton) {
        showCurrentLocationAndEvents()
    }
    
    func getEvents(nearGeoPoint: PFGeoPoint) {
        let query = PFQuery(className:ExploraEvent.parseClassName())
        query.whereKey("event_location", nearGeoPoint:nearGeoPoint)
        query.limit = 10
        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.events = objects as? [ExploraEvent]
                print("Successfully retrieved \(objects!.count) events.")
                self.addEventsToMap()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        })
    }

    func addEventsToMap() {
        if events != nil {
            for event in events! {
                addEventToMap(event)
            }
        }
    }

    func addEventToMap(event: ExploraEvent){
        if event.eventLocation != nil {
            let pin = ExploraPointAnnotation.init(event: event)
//            pin.event = event
//            print("title \(event.eventTitle)")
            self.mapView.addAnnotation(pin)
        }
    }

    func showCurrentLocationAndEvents() {
        let lastKnownLocation = PFUser.currentUser()?.lastKnownLocation
        
        if lastKnownLocation != nil {
            let coordinates = CLLocationCoordinate2DMake(lastKnownLocation!.latitude, lastKnownLocation!.longitude)
            self.mapView.setCenterCoordinate(coordinates, zoomLevel: 12.0, animated: true)
            self.getEvents(lastKnownLocation!)
        } else {
        PFGeoPoint.geoPointForCurrentLocationInBackground({ (geopoint: PFGeoPoint?, error: NSError?) -> Void in
                let coordinates = CLLocationCoordinate2DMake(geopoint!.latitude, geopoint!.longitude)
                self.mapView.setCenterCoordinate(coordinates, zoomLevel: 12.0, animated: true)
                self.getEvents(geopoint!)
            })
        }
    }

    // MARK: - Mapbox delegate

    // Use the default marker; see our custom marker example for more information
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("people")

        if annotationImage == nil {
            let image = UIImage(named: "people")
            annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: "people")
        }

        return annotationImage
    }

    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        if annotation is ExploraPointAnnotation {
            return true
        } else {
            return false
        }
    }

    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {

        self.performSegueWithIdentifier("detailSegue", sender: annotation)
    }

    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        let arrowButton = UIButton.init(type: UIButtonType.System) as UIButton
        arrowButton.frame = CGRectMake(50, 50, 50, 50)

        let arrowImage = UIImage.init(named: "arrow") as UIImage?
        arrowButton.setImage(arrowImage, forState: UIControlState.Normal)

        return arrowButton
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let annotation = sender as! ExploraPointAnnotation
        let vc = segue.destinationViewController as! EventDetailViewController
        vc.event = annotation.event
    }


}
