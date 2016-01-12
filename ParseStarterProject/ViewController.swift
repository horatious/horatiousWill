/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var logibButton: UIButton!
    
    @IBOutlet weak var registeredText: UILabel!
    
    var signupActive = true
    
    var activityindicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String){
        
        if #available(iOS 8.0, *) {
            var alert =  UIAlertController(title: title, message: message ,preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        } else {
            // Fallback on earlier versions
        }

    }
    var errorMessage = "Try again later"

    
    @IBAction func signUp(sender: AnyObject) {
        if username.text == "" || password.text == ""
        {
            displayAlert("error", message:"plese enter something")
        
        }else{
            activityindicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityindicator.center = self.view.center
            activityindicator.hidesWhenStopped = true
            activityindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityindicator)
            activityindicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            if signupActive == true{
                
                
        
            
            var user = PFUser()
                        user.username = username.text
            user.password = password.text
            
            user.signUpInBackgroundWithBlock({ (sucess, error) -> Void in
                self.activityindicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil{
                    
                    //signup
                    self.performSegueWithIdentifier("login", sender: self)
                    
                    
                }else{
                    if let errorString = error!.userInfo["error"] as? String {
                      self.errorMessage = errorString
            
                    }
                    self.displayAlert("failed sign up", message: self.errorMessage)
                }
                
                
                
            })
            
            }else{//ends if signup active tester
                
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    self.activityindicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil{
                        
                        //loggin in
                        self.performSegueWithIdentifier("login", sender: self)
                        
                        
                    }else{
                        
                        if let errrorString = error!.userInfo["error"] as? String{
                             self.errorMessage = errrorString
                            
                        }
                        
                        self.displayAlert("failed log in", message: self.errorMessage)

                    }
                    
                })
                
                
            }
            
        }
        
    }
   
    @IBAction func signIn(sender: AnyObject) {
        
        if signupActive == true {
            signupButton.setTitle("log in", forState: UIControlState.Normal)
            registeredText.text = "not registered"
            
            logibButton.setTitle("sign up", forState: UIControlState.Normal)
            
            signupActive = false
            
        }else{
            
            signupButton.setTitle("Sign up", forState: UIControlState.Normal)
            registeredText.text = "already registered"
            
            logibButton.setTitle("log in", forState: UIControlState.Normal)
            
            signupActive = true
            
            
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil{
            //the user is already logged in
            self.performSegueWithIdentifier("login", sender: self)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
