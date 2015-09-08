//
//  SXTableViewController.swift
//  News163
//
//  Created by panqiang on 15/8/6.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class SXTableViewController: UITableViewController {
    
    var index:NSInteger?
    
    var update:Bool?
    
    var urlString:String?
    
    var arrayList:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadData")
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.update = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (self.update == true) {
            self.tableView.header.beginRefreshing()
            self.update = false
        }
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "contentStart", object: nil))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func loadData() {
        // http://c.m.163.com//nc/article/headline/T1348647853363/0-30.html
        let allUrlString:String = "/nc/article/\(self.urlString!)/0-20.html"
        self.loadDataByType(1, allUrlString: allUrlString)
    }
    
    func loadMoreData() {
        let allUrlString:String = "/nc/article/\(self.urlString!)/\(self.arrayList!.count - self.arrayList!.count%10)-20.html"
        self.loadDataByType(2, allUrlString: allUrlString)
    }
    
    func loadDataByType(type:Int,allUrlString:String) {
        NetworkTools.sharedNetworkTools().GET(allUrlString, parameters: nil, success: { (task:NSURLSessionDataTask!, responseObject:AnyObject!) -> Void in
            println("news:\(responseObject)")
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            let key:String = responseObject.keyEnumerator().nextObject() as! String
            let temArray:NSArray = responseObject[key] as! NSArray
            var arrayM:NSMutableArray = NewsModel.objectArrayWithKeyValuesArray(temArray)
            
            if (type == 1) {
                self.arrayList = arrayM
                self.tableView.header.endRefreshing()
                self.tableView.reloadData()
            } else if (type == 2) {
                self.arrayList!.addObjectsFromArray(arrayM as [AnyObject])
                self.tableView.footer.endRefreshing()
                self.tableView.reloadData()
            }
            
        }) { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
            println("error:\(error)")
        }.resume()
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
        if (self.arrayList != nil) {
            return self.arrayList!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let newsModel:NewsModel = self.arrayList?[indexPath.row] as! NewsModel
        
        let id:String = SXNewsCell.idForRow(newsModel)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(id, forIndexPath: indexPath) as! SXNewsCell
        
        cell.setnewsModel(newsModel)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let newsModel:NewsModel = self.arrayList?[indexPath.row] as! NewsModel
        return SXNewsCell.heightForRow(newsModel)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var vc:UIViewController = UIViewController()
        vc.view.backgroundColor = UIColor.yellowColor()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.destinationViewController.isKindOfClass(DetailController.classForCoder())) {
            let x = self.tableView.indexPathForSelectedRow()!.row
            var dest:DetailController = segue.destinationViewController as! DetailController
            dest.newsModel = self.arrayList?.objectAtIndex(x) as! NewsModel
            self.navigationController?.interactivePopGestureRecognizer.delegate = nil
        } else {
            let x = self.tableView.indexPathForSelectedRow()!.row
            println("no")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row != 0) {
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }

}
