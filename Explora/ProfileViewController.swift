//
//  ProfileViewController.swift
//  Explora
//
//  Created by admin on 10/26/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var profileHeaderView: ProfileTableHeaderView?
    
    var user: PFUser? {
        didSet {
            updateProfileHeaderView()
        }
    }
    
    var userEvents: [ExploraEvent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(EventBriefTableViewCell.self, forCellReuseIdentifier: "eventCell")
        
        if (user == nil) {
            PFUser.currentUser()?.fetchInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if (error == nil) {
                    if let updatedUser = object as? PFUser {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.user = updatedUser
                        })
                    }
                }
            })
            self.user = PFUser.currentUser()
            setUpProfileHeaderView()
            fetchExploraEvents()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
    }
    
    func setUpProfileHeaderView() {
        profileHeaderView = ProfileTableHeaderView.loadViewFromNib()
        if let url = user!.pictureURL {
            profileHeaderView!.imageURL = url
        }
        if let name = user!.firstName {
            profileHeaderView!.username = name
        } else {
            profileHeaderView!.username = user!.username
        }
        self.tableView.tableHeaderView = profileHeaderView!
    }
    
    func updateProfileHeaderView() {
        if let url = user?.pictureURL {
            profileHeaderView?.imageURL = url
        }
        if let name = user?.firstName {
            profileHeaderView?.username = name
        } else {
            profileHeaderView?.username = user!.username
        }
    }
    
    func fetchExploraEvents() {
        if user != nil {
            let query = PFQuery(className: ExploraEvent.parseClassName())
            query.whereKey("creator_id", containsString: user?.objectId!)
            query.findObjectsInBackgroundWithBlock({ (events: [PFObject]?, error: NSError?) -> Void in
                print("events: \(events)")
                self.userEvents = events as? [ExploraEvent]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userEvents?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as! EventBriefTableViewCell
        if let events = self.userEvents {
            let event = events[indexPath.row]
            cell.textLabel?.text = event.eventTitle
        }
        return cell
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
