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

class CreateEventViewController: UIViewController, MGLMapViewDelegate {
    private var mapView: MGLMapView!
    private var old_locValue = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUpLocation()
        
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //mapView.setCenterCoordinate((mapView.userLocation?.coordinate)!, zoomLevel: 15, animated: true)
        
        view.addSubview(mapView)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func mapViewWillStartLocatingUser(mapView: MGLMapView) {
        print("starting")
        print("Latitude \(mapView.centerCoordinate.latitude) \n longitude \(mapView.centerCoordinate.longitude)")
        
    }
    
    func mapView(mapView: MGLMapView, didUpdateUserLocation userLocation: MGLUserLocation?) {
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!), zoomLevel: 15, animated: false)
        
        // Initialize and add the marker annotation
        let point = MGLPointAnnotation()
        
        point.coordinate = CLLocationCoordinate2DMake((userLocation?.coordinate.latitude)!, (userLocation?.coordinate.longitude)!)
        
        //point.coordinate = CLLocationCoordinate2DMake(37.33233141, -122.0312186)
        point.title = "Create an Event"
        
        print("Latitude \(mapView.centerCoordinate.latitude) \n longitude \(mapView.centerCoordinate.longitude)")
        
        mapView.addAnnotation(point)

        
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
