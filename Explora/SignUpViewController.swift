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

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        if (!validateFields()) {
            // Do nothing if fields are not valid
            return;
        }
        let user = PFUser()
        user.username = self.usernameField.text
        user.password = self.passwordField.text
        user.email = self.emailField.text
        
        // other fields can be set just like with PFObject
        user.createdEvents = []
        user.participatingEvents = []
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print (errorString)
                let alertController = UIAlertController(title: "Error Signing Up", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(button)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // Hooray! Let them use the app now.
                print ("success signing up")
                let alertController = UIAlertController(title: "Success", message: "Sign up was successful!", preferredStyle: UIAlertControllerStyle.Alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.delegate?.handleLoginSuccess(user)
                    })
                })
                alertController.addAction(button)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpWithFacebookButtonPressed(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(nil) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                user.getUserInfo()
                let message = "Sign up was successful!"
                print(message)
                let alertController = UIAlertController(title: "Facebook Signup", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let button = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.delegate?.handleLoginSuccess(user)
                    })
                })
                alertController.addAction(button)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                let message = "Uh oh. There was an error signing up through Facebook."
                print(message)
                let alertController = UIAlertController(title: "Facebook Signup", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(button)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func validateFields() -> Bool {
        var valid = true
        var errorMessage = ""
        if (self.usernameField.text == "") {
            valid = false
            errorMessage = "Please fill in a user name."
        } else if (self.emailField.text == "") {
            valid = false
            errorMessage = "Please fill in an email."
        } else if (self.passwordField.text == "") {
            valid = false
            errorMessage = "Please fill in a password."
        }
        if !valid {
            let alertController = UIAlertController(title: "Error Signing Up", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(button)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        return valid
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
