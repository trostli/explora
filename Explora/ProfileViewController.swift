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

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: PFUser? {
        didSet {
            if let url = user!.pictureURL {
                self.profileImageView.setImageWithURL(NSURL(string: url)!)
            }
            if let name = user!.firstName {
                self.usernameLabel.text = name
            } else {
                self.usernameLabel.text = user!.username
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if (user == nil) {
            PFUser.currentUser()?.fetchInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if (error == nil) {
                    if let updatedUser = object as? PFUser {
                        self.user = updatedUser
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                        })
                    }
                }
            })
            self.user = PFUser.currentUser()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.createdEvents?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        if let events = user?.createdEvents {
            cell.textLabel?.text = events[indexPath.row]
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
