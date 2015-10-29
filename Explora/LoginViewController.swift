//
//  LoginViewController.swift
//  Explora
//
//  Created by admin on 10/21/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
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
                    self.getUserInfo()
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
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let username = usernameField.text!;
        let password = passwordField.text!;
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                print(user)
            } else {
                // The login failed. Check error to see why.
                print(error)
            }
        }
    }
    
    func getUserInfo() {
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil) {
                    let dict = result as! NSDictionary
                    if let user = PFUser.currentUser() {
                        user.firstName = dict["first_name"] as? String
                        user.pictureURL = dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String
                        user.saveEventually()
                    }
                }
            })
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
