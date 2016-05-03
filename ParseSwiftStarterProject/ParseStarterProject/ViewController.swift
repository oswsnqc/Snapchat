//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet var userName: UITextField!
    
    
    @IBAction func signIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(userName.text, password:"mypass") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                println("logged in")
                
                self.performSegueWithIdentifier("showUsers", sender: self)
                
                
            } else {
                
                var user = PFUser()
                user.username = self.userName.text
                user.password = "mypass"
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        
                        println("Signed up")
                        self.performSegueWithIdentifier("showUsers", sender: self)
                        
                        
                    } else {
                        println("errorsssssss")
                    }
                }
                
                
            }
        }
        
        
        
        
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser()?.username != nil {
            
            self.performSegueWithIdentifier("showUsers", sender: self)
            
        }
        
    }
        
        
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

