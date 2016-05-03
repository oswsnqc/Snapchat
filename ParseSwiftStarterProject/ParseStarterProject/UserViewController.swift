//
//  UserViewController.swift
//  ParseStarterProject
//
//  Created by Yisen on 8/3/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var userArray: [String] = []
    
    var activeRecipient = 0
    
    var timer = NSTimer()
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        var imageToSend = PFObject(className: "image")
        imageToSend["photo"] = PFFile(name:"image.jpg", data: UIImageJPEGRepresentation(image, 0.5))
        imageToSend["senderUsername"] = PFUser.currentUser()?.username
        imageToSend["recipientUsername"] = userArray[activeRecipient]
        imageToSend.save()
        
        
        
        
        
    }
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)

    
    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        var query = PFUser.query()
        
        if PFUser.currentUser()?.username != nil {
            
            query!.whereKey("username", notEqualTo: PFUser.currentUser()!.username!)
        }
        
        
        var users = query!.findObjects()
        
        if let users = users as? [PFUser] {
            for user in users {
                
                
                userArray.append(user.username!)
                
                tableView.reloadData()
                
            }
        }
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("checkForMessage"), userInfo: nil, repeats: true)
        
        
    }
    
    
    
    func checkForMessage() {
        
        println("check for message")
        
        var query = PFQuery(className: "image")
        query.whereKey("recipientUsername", equalTo: PFUser.currentUser()!.username!)
        
        var images = query.findObjects()
        
        var done = false
        
        
        if let images = images as? [PFObject] {
            for image in images {
                if done == false {
                    
                    var imageView: PFImageView = PFImageView()
                    imageView.file = image["photo"] as? PFFile
                    
                    imageView.loadInBackground({ (photo, error) -> Void in
                        
                        
                        if error == nil {
                            
                            var senderUsername = ""
                            
                            if image["senderUsername"] != nil {
                                
                                
                                senderUsername = image["senderUsername"] as! String
                                
                            } else {
                                
                                senderUsername = ""
                            }
                            

                            
                            var alert = UIAlertController(title: "你有一条新消息", message: "发件人：\(senderUsername)", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alert.addAction(UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                var backgroundView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                                backgroundView.backgroundColor = UIColor.blackColor()
                                backgroundView.alpha = 0.8
                                backgroundView.tag = 3
                                self.view.addSubview(backgroundView)
                                
                                
                                
                                var displayedImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                                
                                displayedImage.image = photo
                                
                                displayedImage.contentMode = UIViewContentMode.ScaleAspectFit
                                
                                displayedImage.tag = 3
                                
                                if displayedImage.image != nil{
                                    
                                    self.view.addSubview(displayedImage)
                                    
                                }
                                
                                image.delete()
                                
                                
                                
                                self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("hideMessage"), userInfo: nil, repeats: false)
                                
                                
                                
                                
                            }))
                            
                            
                            
                           self.presentViewController(alert, animated: true, completion: nil)
                            
                            
                          
                            
                        }
                        
                        
                    })
                    
                
                
                
                    done == true
                }
                
            }
        }


        
        
        
        
    }
    
    
    func hideMessage() {
        
        
        for subview in self.view.subviews {
            
            if subview.tag == 3 {
                
                subview.removeFromSuperview()
                
                
            }
            
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return userArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

          cell.textLabel?.text = userArray[indexPath.row]

        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        activeRecipient = indexPath.row
        
        chooseImage(self)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logout" {
            
            PFUser.logOut()
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    

}
