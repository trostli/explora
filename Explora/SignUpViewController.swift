//
//  SignUpViewController.swift
//  Explora
//
//  Created by admin on 10/18/15.
//  Copyright © 2015 explora-codepath. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        let user = PFUser()
        user.username = self.emailField.text
        user.password = self.passwordField.text
        user.email = self.emailField.text
        
        // other fields can be set just like with PFObject
        user.createdEvents = ["blahblah", "meh"]
        user.participatingEvents = ["testing", "hah"]
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print (errorString)
            } else {
                // Hooray! Let them use the app now.
                print ("success signing up")
            }
        }
    }
    
    @IBAction func signUpWithFacebookButtonPressed(sender: AnyObject) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
