//
//  ViewController.swift
//  showcase-dev
//
//  Created by Cex on 08/08/2016.
//  Copyright © 2016 newmediatechies. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {

    //@IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//-----pulls the standard fb button from facebook and puts in middle of screen
//        let loginButton = FBSDKLoginButton()            
//        loginButton.center = self.view.center
//        self.view!.addSubview(loginButton)
    }

    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is logged in, do work such as go to next view controller.
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
//-----pulls the standard fb button from facebook and puts in middle of screen
//        func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            loginButton.readPermissions = ["email"]
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) in
            
            if facebookError != nil {
                print("Facebook login failed. Error: \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("successful facebook login. \(accessToken)")
          
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential, completion:  { (user, error) in
          if error != nil {
            print("Login failed. \(error)")
        } else {
            print("Logged in! \(user)")
            
            let userData = ["provider": credential.provider] //links firebase user id to facebooks user id
            DataService.ds.createFirebaseUser(user!.uid, user: userData)
            
            NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID) //saves user's Id
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
      })
    }
  }
}
//login w/ email instead of facebook
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            FIRAuth.auth()!.signInWithEmail(email, password: pwd, completion: { (user, error) in
                if error != nil {
                    print(error!.code)
                    
                    if error!.code == STATUS_ACCOUNT_NONEXIST {   //if a/c doesnt exist create new ac
                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
                            
                            if error != nil {
                                self.showErrorAlert("Could not create account  ", msg: "Problem creating account. Please check and try again")
                            } else {
                                //save details
                                NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                                
                                let userData = ["provider": "email"]
                                DataService.ds.createFirebaseUser(user!.uid, user: userData)
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                            
                        })
                    } else {
                        self.showErrorAlert("couldnt log you in", msg: "gutted! haha")
                    }
                } else {
                   self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })

        } else {
            showErrorAlert("Emil and password Required", msg: "You must enter both")   //ac exists so log in
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
