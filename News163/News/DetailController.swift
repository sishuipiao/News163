//
//  DetailController.swift
//  News163
//
//  Created by panqiang on 15/8/28.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class DetailController: UIViewController,UIWebViewDelegate {

    var newsModel:NewsModel!
    var index:Int?
    var detailModel:DetailModel?
    
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var webView: UIWebView!
    var navItem:UIButton!
    
    lazy var replyModels:NSMutableArray? = {
        var array = NSMutableArray()
        return array
    }()
    
    lazy var news:NSArray? = {
        var array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("NewsURLs.plist", ofType: nil)!)
        return array
    }()
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var image = UIImage(named: "contentview_commentbacky")
        image = image?.stretchableImageWithLeftCapWidth(Int(image!.size.width/2), topCapHeight: Int(image!.size.width/2))
        
        var imageSel = UIImage(named: "contentview_commentbacky_selected")
        imageSel = imageSel?.stretchableImageWithLeftCapWidth(Int(imageSel!.size.width/2), topCapHeight: Int(imageSel!.size.width/2))
        
        var rightItem = UIButton()
        self.headView.addSubview(rightItem)
        rightItem.setBackgroundImage(image, forState: UIControlState.Normal)
        rightItem.setBackgroundImage(imageSel, forState: UIControlState.Highlighted)
        rightItem.titleLabel?.font = UIFont.systemFontOfSize(13)
        rightItem.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        self.navItem = rightItem
        
        let url = "http://c.m.163.com/nc/article/\(self.newsModel.docid!)/full.html"
        SXHTTPManager.shareManager().GET(url, parameters: nil, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            println(responseObject)
            self.detailModel = DetailModel(keyValues: responseObject[self.newsModel.docid!])
            self.setRightItem("\(self.detailModel!.replyCount!)回帖")
            self.showInWebView()
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println("error:\(error.description)")
        }
        
        // Do any additional setup after loading the view.
    }
    
    func showInWebView() {
        var html = String(format: "<html><head><link rel=\"stylesheet\" href=\"%@\"></head><body>%@</body></html>", NSBundle.mainBundle().URLForResource("SXDetails.css", withExtension: nil)!,self.touchBody())
        println(html)
        self.webView.loadHTMLString(html, baseURL: nil)
    }
    
    func touchBody() -> String {
        let time = self.detailModel?.ptime
        let timedate = Tools.dateFromString(time!)
        let timeStr = Tools.mmddHHmmFromDate(timedate)
        
        var body:NSString = String(format: "<div class=\"title\">%@</div><span class=\"time\">%@</span><span class=\"source\">%@</span>", self.detailModel!.title!,timeStr,self.detailModel!.source!) as NSString
        if (self.detailModel?.body != nil ) {
            body = body.stringByAppendingString(self.detailModel!.body!)
        }
        
        if (self.detailModel?.img?.count != 0) {
            for index in 0...self.detailModel!.img!.count - 1 {
                let imgModel:DetailImgModel =  DetailImgModel(keyValues: self.detailModel?.img?.objectAtIndex(index))
                
                var width:CGFloat = mainWidth * 0.96
                var height:CGFloat = width/1.4
                
                if (imgModel.pixel != nil) {
                    var pixel:Array = imgModel.pixel!.componentsSeparatedByString("*")
                    width = CGFloat(pixel.first!.toInt()!)
                    height = CGFloat(pixel.last!.toInt()!)
                    
                    var maxWidth = mainWidth * 0.96
                    if (width > maxWidth) {
                        height = maxWidth / width * height
                        width = maxWidth
                    }
                }
                
                let onload = "this.onclick = function() {"
                "  window.location.href = 'sx:src=' +this.src;"
                "}"
                
                var imgHtml = String(format: "<div class=\"img-parent\"><img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\"></div>", onload,width,height,imgModel.src!)
                body = body.stringByReplacingOccurrencesOfString(imgModel.ref!, withString: imgHtml, options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, body.length))
            }
        }
        body = body.stringByReplacingOccurrencesOfString("　", withString: "")
        return body as String
    }
    
    func setRightItem(str:NSString) {
        let size = str.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(13)])
        self.navItem.frame = CGRect(x: mainWidth - size.width - 25, y: 0, width: size.width + 20, height: 44)
        self.navItem.setTitle(str as String, forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC/5))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.changeStatusBar()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeStatusBar() {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    

    @IBAction func backBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
