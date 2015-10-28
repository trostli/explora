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

    weak var mapView: MGLMapView!

    var userLocation: PFGeoPoint?
    var events: [ExploraEvent]?
    var inSetLocationMode: Bool?
    
    let geoCoder = CLGeocoder()
    
    private var _newEventAddressString: String?
    let eventLocationTextView = UITextView()
    @IBOutlet weak var setLocationButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var setLocationStackView: UIStackView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var createEventButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inSetLocationMode = false
        setLocationStackView.hidden = true

        // initialize the map view
        let styleURL = NSURL(string: "asset://styles/light-v8.json")
        mapView = MGLMapView(frame: view.bounds, styleURL: styleURL)
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        // intialize text view
        eventLocationTextView.backgroundColor = UIColor.whiteColor()
        eventLocationTextView.frame = CGRectMake(10, 40, 300, 40)
        eventLocationTextView.editable = false
        eventLocationTextView.hidden = true
        self.view.addSubview(eventLocationTextView)

        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)

        showCurrentLocationAndEvents()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentLocationButton.layer.cornerRadius = 25
        currentLocationButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onCreateEventTap(sender: UIButton) {
        transitionToCreateEventMode()
    }
    
    @IBAction func onCurrentLocationTap(sender: UIButton) {
        showCurrentLocationAndEvents()
    }
    
    @IBAction func onSetLocationTap(sender: UIButton) {
        let newEvent = ExploraEvent()
        if _newEventAddressString != nil {
            newEvent.eventAddress = _newEventAddressString!
        }
        
        newEvent.eventLocation = PFGeoPoint(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)

        // Perform segue to create event details VC here and pass newEvent
        print("Perform segue to Create Event Details VC ")
    }
    
    func transitionToCreateEventMode() {
        inSetLocationMode = true
        createEventButton.hidden = true
        setLocationStackView.hidden = false
        eventLocationTextView.hidden = false
    }
    
    func getAddressStringFromCoords(coordinate: CLLocationCoordinate2D) {
        var placemark:CLPlacemark!
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if error != nil {
                print("Reverse Geocode failed with error: \(error!.localizedDescription)")
            } else {
                if placemarks!.count > 0 {
                    placemark = CLPlacemark(placemark: (placemarks?.first)!)
                    
                    let newEventFormattedAddressArray = placemark.addressDictionary?["FormattedAddressLines"] as? NSArray
                    self._newEventAddressString = newEventFormattedAddressArray?.componentsJoinedByString("\n")
                    if let street = placemark.addressDictionary?["Name"] as? NSString {
                        self.updateLocationInTextView(street)
                    }
                }
            }
        }
    }
    
    func updateLocationInTextView(locationString: NSString) {
        let titleString = "Event Location"
        //let locationString = getLocStringFromCoords(newLocCoords)
        
        
        let textString = "\(titleString)\n\(locationString)"
        let attrText = NSMutableAttributedString(string: textString)
        
        let largeFont = UIFont(name: "Arial", size: 14.0)!
        let smallFont = UIFont(name: "Arial", size: 11.0)!
        
        //  Convert textString to NSString because attrText.addAttribute takes an NSRange.
        let titleTextRange = (textString as NSString).rangeOfString(titleString)
        let locationTextRange = (textString as NSString).rangeOfString(locationString as String)
        
        attrText.addAttribute(NSFontAttributeName, value: smallFont, range: titleTextRange)
        attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: titleTextRange)
        attrText.addAttribute(NSFontAttributeName, value: largeFont, range: locationTextRange)
        
        eventLocationTextView.attributedText = attrText
        eventLocationTextView.textAlignment = .Center
        
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
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        if self.inSetLocationMode == true {
            getAddressStringFromCoords(mapView.centerCoordinate)
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let annotation = sender as! ExploraPointAnnotation
        let vc = segue.destinationViewController as! EventDetailViewController
        vc.event = annotation.event
    }


}
