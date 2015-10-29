//
//  ReplyController.swift
//  News163
//
//  Created by panqiang on 15/9/7.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class ReplyController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var replys:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replys!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("replyCell", forIndexPath: indexPath) as! ReplyCell
        
        let reply:ReplyModel = self.replys[indexPath.row] as! ReplyModel
        
        if (reply.img != nil) {
            cell.headImg.setImageWithURL(NSURL(string: reply.img!)!, placeholderImage: UIImage(named: ""))
        }else{
            cell.headImg.image = UIImage(named: "comment_profile_default")
        }
        cell.nameLabel.text = reply.name == nil ? "火星网友" : reply.name
        cell.locateLabel.text = Tools.filterNBSP(reply.locate!)
        cell.commendLabel.text = Tools.filterNBSP(reply.commend!)
        cell.replyCoutLabel.text = reply.up?.stringValue
        
        return cell
    }
    
    @IBAction func popBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
