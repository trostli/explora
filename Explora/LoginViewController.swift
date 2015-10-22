//
//  LoginViewController.swift
//  Explora
//
//  Created by admin on 10/21/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginToFacebook() {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(nil) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    let message = "User signed up and logged in through Facebook!"
                    print(message)
                    let alertController = UIAlertController(title: "Facebook Signin", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(button)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let message = "User logged in through Facebook!"
                    print(message)
                    let alertController = UIAlertController(title: "Facebook Signin", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(button)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                let message = "Uh oh. The user cancelled the Facebook login."
                print(message)
                let alertController = UIAlertController(title: "Facebook Signin", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(button)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func facebookSignInButtonPressed(sender: AnyObject) {
        loginToFacebook()
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
