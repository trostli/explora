//
//  EventDetailViewController.swift
//  Explora
//
//  Created by Daniel Trostli on 10/21/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Mapbox
import Parse

class EventDetailViewController: UIViewController, MGLMapViewDelegate, LoginDelegate {

    var event: ExploraEvent!
    weak var mapView: ExploraMapView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventMeetingTimeLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var mapViewContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTitleLabel.text = event.eventTitle
        eventDescriptionLabel.text = event.eventDescription
        eventAddressLabel.text = event.eventAddress

        let formatter = NSDateFormatter() //Should be cached somewhere since this is expensive
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .ShortStyle
        
        if event.meetingStartTime != nil {
            let meetingStartTimeString = formatter.stringFromDate(event.meetingStartTime!)
            eventMeetingTimeLabel.text = meetingStartTimeString
        }
        
        // initialize the map view
        let styleURL = NSURL(string: "asset://styles/emerald-v8.json")
        mapView = ExploraMapView(frame: mapViewContainerView.bounds, styleURL: styleURL)
        mapView.scrollEnabled = false
        mapView.delegate = self
        mapView.setCenterCoordinate(event.eventCoordinate!, zoomLevel: 14.0, animated: false)
        mapView.addEventToMap(event)

        mapViewContainerView.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onJoinTap(sender: UIButton) {
        if PFUser.currentUser() != nil {
            joinEvent(PFUser.currentUser()!)
        } else {
            let storyboard = UIStoryboard(name: "LoginFlow", bundle: nil)
            if let loginNavVC = storyboard.instantiateInitialViewController() as? UINavigationController {
                if let loginVc = loginNavVC.topViewController as? LoginViewController {
                    loginVc.delegate = self;
                }
                self.presentViewController(loginNavVC, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Login delegate
    
    func handleLoginSuccess(user: PFUser) {
        print(user)
        joinEvent(user)
    }
    
    func joinEvent(user: PFUser) {
        let attendeesRelation = self.event.attendees
        attendeesRelation?.addObject(user)
        self.event.saveInBackgroundWithBlock { (success: Bool, error:NSError?) -> Void in
            if success {
                self.handleSuccessfulJoin()
            } else {
                self.handleErrorJoin()
            }
        }
    }
    
    func handleSuccessfulJoin() {
        let alertController = UIAlertController(title: "Success", message: "Thanks for joining the event! Have fun!", preferredStyle: UIAlertControllerStyle.Alert)
        let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(button)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func handleErrorJoin() {
        let alertController = UIAlertController(title: "Error", message: "Sorry, there was an error in joining the event, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
        let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(button)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Mapbox delegate

    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage : MGLAnnotationImage?
        if let exploraAnnotation = annotation as? ExploraPointAnnotation {
            annotationImage = exploraAnnotation.exploraPointAnnotation(imageForEventCategory: mapView)
        }
        return annotationImage
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
