//
//  SXMainViewController.swift
//  News163
//
//  Created by panqiang on 15/8/3.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class SXMainViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var smallScrollView: UIScrollView!
    
    @IBOutlet weak var bigScrollView: UIScrollView!
    
    var oldTitleLabel:SXTitleLabel?
    
    var beginOffsetX:CGFloat?
    
    var rightItem:UIButton!
    
    var isWeatherShow:Bool!
    
    var weatherModel:WeatherModel?
    
    var weatherView:WeatherView?
    
    var tran:UIImageView?
    
    //懒加载
    lazy var arrayLists:NSArray? = {
        var array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("NewsURLs.plist", ofType: nil)!)
        return array
    }()
    
    //页面首次加载
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isWeatherShow = false
        self.automaticallyAdjustsScrollViewInsets = false //让你以坐标 0,0 fullScreen 布局
        self.smallScrollView.showsHorizontalScrollIndicator = false
        self.smallScrollView.showsVerticalScrollIndicator = false
        self.bigScrollView.delegate = self;
        
        self.addController()
        self.addLabel()
        
        let contentX = self.childViewControllers.count * Int(mainWidth)
        self.bigScrollView.contentSize = CGSize(width: contentX, height: 0)
        self.bigScrollView.pagingEnabled = true
        
        //添加默认控制器
        var vc:UIViewController = self.childViewControllers.first as! UIViewController
        vc.view.frame = self.bigScrollView.bounds
        self.bigScrollView.addSubview(vc.view)
        
        //添加默认高亮label
        var label:SXTitleLabel = self.smallScrollView.subviews.first as! SXTitleLabel
        label.setScale(1.0)
        self.bigScrollView.showsHorizontalScrollIndicator = false
        
        let originX = Int(mainWidth - 45)
        var rightItem:UIButton = UIButton(frame: CGRect(x: originX, y: 20, width: 45, height: 45))
        self.rightItem = rightItem
        var win:UIWindow = (UIApplication.sharedApplication().windows as NSArray).firstObject as! UIWindow
        win.addSubview(rightItem)
        rightItem.setImage(UIImage(named: "top_navigation_square"), forState: UIControlState.Normal)
        rightItem.addTarget(self, action: "rightItemClick", forControlEvents: UIControlEvents.TouchUpInside)
        println("rightitem.frame:\(rightItem.frame)")
        
        self.sendWeatherRequest()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.rightItem.alpha = 1
        self.rightItem.enabled = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.rightItem.transform = CGAffineTransformIdentity
        self.rightItem.setImage(UIImage(named: "top_navigation_square"), forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //添加子控制器
    func addController() {
//        for index in 0...self.arrayLists!.count-1
        for var index = 0; index < self.arrayLists!.count; ++index {
            var vc:SXTableViewController = UIStoryboard(name: "News", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as! SXTableViewController
            vc.title = self.arrayLists?[index]["title"] as? String
            vc.urlString = self.arrayLists?[index]["urlString"] as? String
            self.addChildViewController(vc)
        }
    }
    
    //添加标题栏
    func addLabel() {
        for index in 0...7 {
            var label = SXTitleLabel(frame: CGRect(x: index * 70, y: 0, width: 70, height: 40))
            var vc:UIViewController = self.childViewControllers[index] as! UIViewController
            label.text = vc.title
            label.font = UIFont(name: "HYQiHei", size: 18)
            label.tag = index
            label.userInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "lblClick:"))
            label.setScale(0.0)
            label.sizeToFit()
            self.smallScrollView.addSubview(label)
        }
        self.smallScrollView.contentSize = CGSize(width: 560, height: 0)
    }
    
    //标题栏label的点击时间
    func lblClick(recognizer:UITapGestureRecognizer) {
        let titleLabel:SXTitleLabel = recognizer.view as! SXTitleLabel
        //self.bigScrollView.contentOffset = CGPoint(x: titleLabel.tag * Int(self.bigScrollView.frame.size.width), y: Int(self.smallScrollView.contentOffset.y))
        self.bigScrollView.setContentOffset(CGPoint(x: titleLabel.tag * Int(self.bigScrollView.frame.size.width), y: Int(self.smallScrollView.contentOffset.y)), animated: false)
        self.selectedIndex(titleLabel.tag)
    }
    
    func selectedIndex(index:Int) {
        let titleLabel:SXTitleLabel = self.smallScrollView.subviews[index] as! SXTitleLabel
        var offsetx = titleLabel.center.x - self.smallScrollView.frame.size.width/2
        let offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width
        if (offsetx < 0) {
            offsetx = 0
        } else if (offsetx > offsetMax) {
            offsetx = offsetMax
        }
        let offset = CGPoint(x: offsetx, y: self.smallScrollView.contentOffset.y)
        self.smallScrollView.setContentOffset(offset, animated: true)
        
        var subViews:NSArray = self.smallScrollView.subviews as NSArray
        subViews.enumerateObjectsUsingBlock { (obj:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if (idx != index) {
                var temLabel:SXTitleLabel = subViews[idx] as! SXTitleLabel
                temLabel.setScale(0.0)
            }
        }
        
        //添加控制器
        var newsVc:SXTableViewController = self.childViewControllers[index] as! SXTableViewController
        newsVc.index = index
        if (newsVc.view.superview != nil) {
            return
        }
        newsVc.view.frame = self.bigScrollView.bounds
        self.bigScrollView.addSubview(newsVc.view)
    }
    
    //滚动结束后调用
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.bigScrollView.frame.size.width)
        self.selectedIndex(index)
    }
    
    //滚动结束
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    //正在滚动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //取出来绝对值，避免最左边往右拉时形变超过1
        let value:CGFloat = abs(scrollView.contentOffset.x / scrollView.frame.size.width)
        let leftIndex:Int = Int(value)
        let rightIndex:Int = leftIndex + 1
        let scaleRight:CGFloat = value - CGFloat(leftIndex)
        let scaleLeft:CGFloat = 1 - scaleRight
        
        var subViews:NSArray = self.smallScrollView.subviews as NSArray
        
        var labelLeft:SXTitleLabel = subViews[leftIndex] as! SXTitleLabel
        labelLeft.setScale(CGFloat(scaleLeft))
        
        //考虑到最后一个模块，如果右边已经没有模块了，就不在下面赋值scale了
        if (rightIndex < self.smallScrollView.subviews.count) {
            var labelRight:SXTitleLabel = subViews[rightIndex] as! SXTitleLabel
            labelRight.setScale(CGFloat(scaleRight))
        }
    }
    
    //获取天气
    func sendWeatherRequest() {
        let url = "http://c.3g.163.com/nc/weather/5YyX5LqsfOWMl%2BS6rA%3D%3D.html"
        SXHTTPManager.shareManager().GET(url, parameters: nil, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            println("responseObject:\(responseObject)")
            let weatherModel:WeatherModel = WeatherModel(keyValues: responseObject)
            self.weatherModel = weatherModel
            self.addWeahter()
            self.rightItem.enabled = true
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println("error:\(error.description)")
        }
    }
    
    //添加天气
    func addWeahter() {
        var weatherView:WeatherView = WeatherView.view()
        weatherView.setWeather(self.weatherModel!)
        self.weatherView = weatherView
        weatherView.frame = CGRect(x: 0, y: 64, width: mainWidth, height: mainHeight - 64)
        weatherView.alpha = 0.9
        
        var tran:UIImageView = UIImageView(image: UIImage(named: "224"))
        self.tran = tran
        tran.frame = CGRect(x: mainWidth - 33, y: 57, width: 7, height: 7)
        
        var win:UIWindow = (UIApplication.sharedApplication().windows as NSArray).firstObject as! UIWindow
        win.addSubview(weatherView)
        win.addSubview(tran)
        
        self.weatherView?.hidden = true
        self.tran?.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushWeatherDetail", name: "pushWeatherDetail", object: nil)
    }
    
    func rightItemClick() {
        if (self.isWeatherShow == true) {
            self.weatherView?.hidden = true
            self.tran?.hidden = true
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, CGFloat(M_1_PI * 5))
                }, completion: { (finished:Bool) -> Void in
                self.rightItem.setImage(UIImage(named: "top_navigation_square"), forState: UIControlState.Normal)
            })
        } else {
            self.rightItem.setImage(UIImage(named: "223"), forState: UIControlState.Normal)
            self.weatherView?.hidden = false
            self.tran?.hidden = false
            self.weatherView?.addAnimate()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, -CGFloat(M_1_PI * 6))
            }, completion: { (finished:Bool) -> Void in
                self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, CGFloat(M_1_PI))
            })
        }
        self.isWeatherShow = !self.isWeatherShow
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
