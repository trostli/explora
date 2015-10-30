//
//  ProfileTableHeaderView.swift
//  Explora
//
//  Created by admin on 10/28/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit

class ProfileTableHeaderView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    static let nibName = "ProfileTableHeaderView"
    
    var imageURL : String? {
        didSet {
            if (profileImageView != nil) {
                profileImageView.setImageWithURL(NSURL(string: imageURL!)!)
            }
        }
    }
    
    var username : String? {
        didSet {
            if (usernameLabel != nil) {
                usernameLabel.text = username!
            }
        }
    }
    
    class func loadViewFromNib() -> ProfileTableHeaderView {
        let bundle = NSBundle(forClass: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! ProfileTableHeaderView
        
        return view
    }
    
    override func awakeFromNib() {
        let image = profileImageView
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        print("Making image a circle")
    }
}
