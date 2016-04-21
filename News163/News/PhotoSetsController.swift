//
//  PhotoSetsController.swift
//  News163
//
//  Created by panqiang on 15/11/4.
//  Copyright © 2015年 panqiang. All rights reserved.
//

import UIKit

class PhotoSetsController: UIViewController {
    
    var newsModel:NewsModel?
    var adsModel:AdsModel?
    var navItem:UIButton!
    var detailModel:DetailModel?
    
    @IBOutlet weak var headView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image = UIImage(named: "contentview_commentbacky")
        image = image?.stretchableImageWithLeftCapWidth(Int(image!.size.width/2), topCapHeight: Int(image!.size.width/2))
        
        var imageSel = UIImage(named: "contentview_commentbacky_selected")
        imageSel = imageSel?.stretchableImageWithLeftCapWidth(Int(imageSel!.size.width/2), topCapHeight: Int(imageSel!.size.width/2))
        
        let rightItem = UIButton()
        rightItem.setBackgroundImage(image, forState: UIControlState.Normal)
        rightItem.setBackgroundImage(imageSel, forState: UIControlState.Highlighted)
        rightItem.titleLabel?.font = UIFont.systemFontOfSize(13)
        rightItem.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        rightItem.addTarget(self, action: #selector(PhotoSetsController.replyDetail), forControlEvents: UIControlEvents.TouchUpInside)
        self.headView.addSubview(rightItem)
        self.navItem = rightItem
        self.navItem.userInteractionEnabled = false
        
        let url = "http://c.m.163.com/nc/article/\(self.newsModel?.docid!)/full.html"
        SXHTTPManager.shareManager().GET(url, parameters: nil, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            print("html:\(responseObject)")
            self.detailModel = DetailModel(keyValues: responseObject[(self.newsModel?.docid)!])
            self.setRightItem("\(self.detailModel!.replyCount!)回帖")
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error:\(error.description)")
        }
        
        print(newsModel)
        print(adsModel)
        // Do any additional setup after loading the view.
    }
    
    func setRightItem(str:NSString) {
        let size = str.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(13)])
        self.navItem.frame = CGRect(x: mainWidth - size.width - 22, y: 0, width: size.width + 20, height: 44)
        self.navItem.setTitle(str as String, forState: UIControlState.Normal)
    }
    
    func replyDetail() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
