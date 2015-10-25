//
//  EventDetailViewController.swift
//  Explora
//
//  Created by Daniel Trostli on 10/21/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    var event: ExploraEvent!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventMeetingTimeLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTitleLabel.text = event.eventTitle
        eventDescriptionLabel.text = event.eventDescription
        eventAddressLabel.text = "123 Townsend St"
        eventMeetingTimeLabel.text = "\(event.meetingStartTime)"
        
        print("\(event.objectId)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onJoinTap(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
