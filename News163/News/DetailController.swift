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
    var commendArray:NSArray?
    
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
        
        let rightItem = UIButton()
        self.headView.addSubview(rightItem)
        rightItem.setBackgroundImage(image, forState: UIControlState.Normal)
        rightItem.setBackgroundImage(imageSel, forState: UIControlState.Highlighted)
        rightItem.titleLabel?.font = UIFont.systemFontOfSize(13)
        rightItem.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        rightItem.addTarget(self, action: "replyDetail", forControlEvents: UIControlEvents.TouchUpInside)
        self.navItem = rightItem
        
        let url = "http://c.m.163.com/nc/article/\(self.newsModel.docid!)/full.html"
        SXHTTPManager.shareManager().GET(url, parameters: nil, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            print(responseObject)
            self.detailModel = DetailModel(keyValues: responseObject[self.newsModel.docid!])
            self.setRightItem("\(self.detailModel!.replyCount!)回帖")
            self.showInWebView()
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            print("error:\(error.description)")
        }
        
        let url2 = "http://comment.api.163.com/api/json/post/list/new/hot/\(self.newsModel.boardid!)/\(self.newsModel.docid!)/0/10/10/2/2"
        SXHTTPManager.shareManager().GET(url2, parameters: nil, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            print(responseObject)
            if (responseObject["hotPosts"] != nil) {
                let array:NSArray = responseObject["hotPosts"] as! NSArray
                self.commendArray = ReplyModel.objectArrayWithKeyValuesArray(array)
            }
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            print("error:\(error.description)")
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }
    
    func showInWebView() {
        let html = String(format: "<html><head><link rel=\"stylesheet\" href=\"%@\"></head><body>%@</body></html>", NSBundle.mainBundle().URLForResource("SXDetails.css", withExtension: nil)!,self.touchBody())
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
                    let pixel:Array = imgModel.pixel!.componentsSeparatedByString("*")
                    width = CGFloat(Int(pixel.first!)!)
                    height = CGFloat(Int(pixel.last!)!)
                    
                    let maxWidth = mainWidth * 0.96
                    if (width > maxWidth) {
                        height = maxWidth / width * height
                        width = maxWidth
                    }
                }
                
                let onload = "this.onclick = function() {"
                "  window.location.href = 'sx:src=' +this.src;"
                "}"
                
                let imgHtml = String(format: "<div class=\"img-parent\"><img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\"></div>", onload,width,height,imgModel.src!)
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
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url:NSString = NSString(CString: request.URL!.absoluteString, encoding: NSUTF8StringEncoding)!
        let range = url.rangeOfString("sx:src=")
        if (range.location != NSNotFound) {
            let begin = range.location + range.length
            let src = url.substringFromIndex(begin)
            self.savePictureToAlbum(src)
            return false
        }
        return true
    }
    
    func savePictureToAlbum(src:String) {
        let alert = UIAlertController(title: "提示", message: "确定要保存到相册吗？", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: { (action:UIAlertAction!) -> Void in
            let cache = NSURLCache.sharedURLCache()
            let request = NSURLRequest(URL: NSURL(string: src)!)
            let data = cache.cachedResponseForRequest(request)
            let img = UIImage(data: data!.data)
            UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil)
        }))
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
    
    func replyDetail() {
//        let storyBoard = UIStoryboard(name: "News", bundle: NSBundle.mainBundle())
        
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
