//
//  HomeViewController.swift
//  Instagram
//
//  Created by Lawrence Chong on 3/15/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit
import Parse


class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [PFObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.reloadTable(_:)), name: "reload", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
    }
    
    func reloadTable(notification: NSNotification){
        // Do any additional setup after loading the view.
        let query = PFQuery(className: "UserInfo")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let post = posts {
            return post.count
        }
        else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as! ImageCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    @IBAction func onCamera(sender: AnyObject) {
        self.performSegueWithIdentifier("hometocamSegue", sender: nil)
    }
    
    @IBAction func onSignOut(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("homeToLoginSegue", sender: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
