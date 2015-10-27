//
//  CreateEventViewController.swift
//  Explora
//
//  Created by Sudipta Bhowmik on 10/20/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class CreateEventViewController: UIViewController, MGLMapViewDelegate, UITextFieldDelegate {
    //private var mapView: MGLMapView!
    
    
    
    @IBOutlet var mapView: MGLMapView!
    private var loc_coords: CLLocationCoordinate2D = CLLocationCoordinate2D()
    private let eventLocText = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        eventLocText.backgroundColor = UIColor.whiteColor()
        eventLocText.frame = CGRectMake(10, 40, 300, 40)
        self.view.addSubview(eventLocText)
        
        let locButton = UIButton()
        locButton.frame = CGRectMake(50,50,200,30)
        locButton.setTitle("Create an event here", forState: .Normal)
        locButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        locButton.center.x = self.view.center.x
        locButton.center.y = self.view.center.y - 20
        locButton.addTarget(self, action: "createButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(locButton)
        
        self.view.bringSubviewToFront(eventLocText)
        self.view.bringSubviewToFront(locButton)

    
        // Do any additional setup after loading the view.
    }
    
    func createButtonPressed(sender: UIButton!) {
        let geoCoder = CLGeocoder()
        
        //Get address string from saved object hered
        let addressString = "cork oak way, palo alto, ca"
       
        geoCoder.geocodeAddressString(addressString) { (placemarks, error) -> Void in
            if error != nil {
                print("Geocode failed with error: \(error!.localizedDescription)")
            } else {
                if placemarks!.count > 0 {
                    let placemark = placemarks?.first
                    let location = placemark!.location
                    self.loc_coords = location!.coordinate
                    print("LAT \(self.loc_coords.latitude), LONG \(self.loc_coords.longitude)")
                    self.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: self.loc_coords.latitude, longitude: self.loc_coords.longitude), zoomLevel: 15, animated: true)
                    self.performSegueWithIdentifier("AddDetailsSegue", sender: self)
                    //self.showMap()
                    
                }
            }

        }
        
        
        //self.performSegueWithIdentifier("AddDetailsSegue", sender: self)
    }
    
    func getLocStringFromCoords(coords: CLLocationCoordinate2D) {
        var pm:CLPlacemark!
        let geoCoder = CLGeocoder()
        let locCoords = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        //print("getLocStringFromCoords lat\(coords.latitude) long \(coords.longitude)")
        geoCoder.reverseGeocodeLocation(locCoords) { (placemarks, error) -> Void in
            if error != nil {
                print("Reverse Geocode failed with error: \(error!.localizedDescription)")
            } else {
                if placemarks!.count > 0 {
                    pm = CLPlacemark(placemark: (placemarks?.first)!)
                
                    if let street = pm.addressDictionary?["Name"] as? NSString {
                        print(street)
                        self.updateLocationInTextView(street)
                        //save location object here
                        
                    }
                    //print("AddressDict - \(pm.addressDictionary)")
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
        
        eventLocText.attributedText = attrText
        eventLocText.textAlignment = .Center
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("in prepare")
        let AddEventDetailsVC = segue.destinationViewController as! AddEventDetailsViewController
        AddEventDetailsVC.coords = loc_coords
    }
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        getLocStringFromCoords(mapView.centerCoordinate)
        //displayEventLoc(mapView.centerCoordinate)
    }
    
    
    func mapView(mapView: MGLMapView, didUpdateUserLocation userLocation: MGLUserLocation?) {
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!), zoomLevel: 15, animated: false)
        
        print("Latitude \(mapView.centerCoordinate.latitude) \n longitude \(mapView.centerCoordinate.longitude)")
        
    }
    
    func mapView(mapView: MGLMapView, didFailToLocateUserWithError error: NSError) {
        print("Error locating user")
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
