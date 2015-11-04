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

protocol LoginDelegate: class {
    func handleLoginSuccess(user: PFUser)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    weak var delegate: LoginDelegate?;
    
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
                user.getUserInfo()
                let message = "You've successfully logged in!"
                print(message)
                let alertController = UIAlertController(title: "Facebook Signin", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let button = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.delegate?.handleLoginSuccess(user)
                    })
                })
                alertController.addAction(button)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                let message = "Uh oh. There was an error logging in through Facebook."
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
            if let user = user {
                // Do stuff after successful login.
                print(user)
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.delegate?.handleLoginSuccess(user)
                })
            } else {
                // The login failed. Check error to see why.
                print(error)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func facebookSignInButtonPressed(sender: AnyObject) {
        loginToFacebook()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SignUp" {
            if let signupVC = segue.destinationViewController as? SignUpViewController {
                signupVC.delegate = self.delegate
            }
        }
    }

}
