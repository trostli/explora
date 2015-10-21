//
//  DiscoveryViewController.swift
//  Explora
//
//  Created by Daniel Trostli on 10/20/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Mapbox
import INTULocationManager

class DiscoveryViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    
    let locationManager = INTULocationManager.sharedInstance()
    var userCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize the map view
        let styleURL = NSURL(string: "asset://styles/light-v8.json")
        mapView = MGLMapView(frame: view.bounds, styleURL: styleURL)
        mapView.showsUserLocation = true

        getCurrentLocation()
        view.addSubview(mapView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Should be move outside of controller to user model
    func getCurrentLocation() {
        locationManager.requestLocationWithDesiredAccuracy(INTULocationAccuracy.Room, timeout: 10.0, delayUntilAuthorized: true) { (currentLocation: CLLocation!, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
            if (status == INTULocationStatus.Success) {
                self.userCoordinates = currentLocation.coordinate
                self.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude),
                    zoomLevel: 15, animated: false)
            }
            else if (status == INTULocationStatus.TimedOut) {
                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                // However, currentLocation contains the best location available (if any) as of right now,
                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
            }
            else {
                // An error occurred, more info is available by looking at the specific status returned.
            }
        }

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
