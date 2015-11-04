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

class EventDetailViewController: UIViewController, MGLMapViewDelegate, LoginDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var event: ExploraEvent!
    weak var mapView: ExploraMapView!
    
    private var currentUserIsOwner = false
    private var currentUserIsAttendee = false
    private var attendeesArray: [PFUser]?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventMeetingTimeLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var mapViewContainerView: UIView!
    @IBOutlet weak var joinEventButton: UIButton!
    @IBOutlet weak var joinEventButtonHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinEventButtonHeight.constant = 0
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setAttendeeState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAttendeeState() {
        let attendeesQuery = event.attendees?.query()
        attendeesQuery?.findObjectsInBackgroundWithBlock({ (attendees: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.attendeesArray = attendees as? [PFUser]
                self.collectionView.reloadData()
                
                if self.attendeesArray?.count > 0 {
                    for attendee in attendees! {
                        let exploraAttendee = attendee as! PFUser
                        print("attendee: \(exploraAttendee.email)")
                        if exploraAttendee.objectId == PFUser.currentUser()?.objectId {
                            self.setCurrentUserIsAttendeeState()
                            print("is attendee!")
                        } else {
                            self.setCurrentUserIsNotAttendeeState()
                        }
                    }
                } else {
                    self.setCurrentUserIsNotAttendeeState()
                }
            } else {
                print("Error getting attendees: \(error?.description)")
            }
        })

    }

    func setCurrentUserIsOwnerState() {

    }

    func setCurrentUserIsAttendeeState() {
        currentUserIsAttendee = true
        self.joinEventButtonHeight.constant = 70
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.joinEventButton.setTitle("Going ✅", forState: .Normal)
            self.joinEventButton.backgroundColor = UIColor(red: 237.0/255.0, green: 145.0/255.0, blue: 71.0/255.0, alpha: 1.0)
            }, completion: nil)
    }
    
    func setCurrentUserIsNotAttendeeState() {
        currentUserIsAttendee = false
        self.joinEventButtonHeight.constant = 70
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.joinEventButton.setTitle("Not Going 🚷", forState: .Normal)
            self.joinEventButton.backgroundColor = UIColor.lightGrayColor()
            }, completion: nil)
    }
    
    @IBAction func onJoinTap(sender: UIButton) {
        if PFUser.currentUser() != nil {
            if currentUserIsAttendee == true {
                unjoinEvent(PFUser.currentUser()!)
            } else {
                joinEvent(PFUser.currentUser()!)
            }
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
        if currentUserIsAttendee == false {
            let attendeesRelation = self.event.attendees
            attendeesRelation?.addObject(user)
            self.event.saveInBackgroundWithBlock { (success: Bool, error:NSError?) -> Void in
                if success {
                    self.setCurrentUserIsAttendeeState()
                    self.handleSuccessfulJoin()
                } else {
                    self.handleError()
                }
            }
        } else {
            print("Cannot Join; user is already attending")
        }
    }
    
    func unjoinEvent(user: PFUser) {
        if currentUserIsAttendee == true {
            let attendeesRelation = self.event.attendees
            attendeesRelation?.removeObject(user)
            self.event.saveInBackgroundWithBlock { (success: Bool, error:NSError?) -> Void in
                if success {
                    self.setCurrentUserIsNotAttendeeState()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.showAlert("Error", message: "Sorry, there was an error, please try again.", dismissViewController: false)
                }
            }
        } else {
            print("Cannot Unjoin; user is not attending")
        }
    }

    func handleSuccessfulJoin() {
        showAlert("Success", message: "Thanks for joining the event! Have fun!", dismissViewController: true)
    }

    func handleError() {
        showAlert("Error", message: "Sorry, there was an error, please try again.", dismissViewController: false)
    }
    
    func showAlert(title: String, message: String, dismissViewController: Bool) {
        let alertController = UIAlertController(title: message, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            if dismissViewController == true {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        alertController.addAction(button)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - CollectionView delegate
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCell
        let attendee = attendeesArray![indexPath.row] as PFUser
        cell.photoImageView.setImageWithURL(NSURL(string: attendee.pictureURL!)!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.attendeesArray != nil {
            print("# of attendees: \(self.attendeesArray!.count)")
            return self.attendeesArray!.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    // MARK: - Mapbox delegate

    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage : MGLAnnotationImage?
        if let exploraAnnotation = annotation as? ExploraPointAnnotation {
            annotationImage = exploraAnnotation.exploraPointAnnotation(imageForEventCategory: mapView)
        }
        return annotationImage
    }

    // MARK: - IBActions
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
