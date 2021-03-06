//
//  SXMainViewController.swift
//  News163
//
//  Created by panqiang on 15/8/3.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit
import CoreLocation

class SXMainViewController: UIViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var smallScrollView: UIScrollView!
    
    @IBOutlet weak var bigScrollView: UIScrollView!
    
    var oldTitleLabel:SXTitleLabel?
    
    var beginOffsetX:CGFloat?
    
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var rightItem: UIButton!
    
    var isWeatherShow:Bool!
    
    var weatherModel:WeatherModel?
    
    var weatherView:WeatherView?
    
    var upView:UIView?
    
    var locationManager:CLLocationManager!
    
    var CLlocation:CLLocation?
    
    //懒加载
    lazy var arrayLists:NSArray? = {
        var array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("NewsURLs.plist", ofType: nil)!)
        return array
    }()
    
    //页面首次加载
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        let bar:UINavigationBar = UINavigationBar(frame: CGRectMake(0, -24, mainWidth, 44))
        bar.setBackgroundImage(Tools.createImageWithColor(UIColor(red: 224/255.0, green: 62/255.0, blue: 63/255.0, alpha: 1)), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        self.view.addSubview(bar)
        
        self.navView.backgroundColor = UIColor(red: 224/255.0, green: 62/255.0, blue: 63/255.0, alpha: 1)
        
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
        let vc:UIViewController = self.childViewControllers.first!
        vc.view.frame = self.bigScrollView.bounds
        self.bigScrollView.addSubview(vc.view)
        
        //添加默认高亮label
        let label:SXTitleLabel = self.smallScrollView.subviews.first as! SXTitleLabel
        label.setScale(1.0)
        self.bigScrollView.showsHorizontalScrollIndicator = false
        
        self.startLocation()
        
        self.sendWeatherRequest()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.rightItem.transform = CGAffineTransformIdentity
        self.rightItem.setImage(UIImage(named: "top_navigation_square"), forState: UIControlState.Normal)
    }
    
    //添加子控制器
    func addController() {
        for index in 0 ..< self.arrayLists!.count {
            let vc:SXTableViewController = UIStoryboard(name: "News", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as! SXTableViewController
            vc.title = self.arrayLists?[index]["title"] as? String
            vc.urlString = self.arrayLists?[index]["urlString"] as? String
            self.addChildViewController(vc)
        }
    }
    
    //添加标题栏
    func addLabel() {
        for index in 0...7 {
            let label = SXTitleLabel(frame: CGRect(x: index * 70, y: 0, width: 70, height: 40))
            let vc:UIViewController = self.childViewControllers[index] 
            label.text = vc.title
//            label.font = UIFont(name: "DS-Digital", size: 18)
            label.tag = index
            label.userInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SXMainViewController.lblClick(_:))))
            label.setScale(0.0)
            label.sizeToFit()
            self.smallScrollView.addSubview(label)
        }
        self.smallScrollView.contentSize = CGSize(width: 560, height: 0)
    }
    
    //标题栏label的点击时间
    func lblClick(recognizer:UITapGestureRecognizer) {
        let titleLabel:SXTitleLabel = recognizer.view as! SXTitleLabel
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
        
        let subViews:NSArray = self.smallScrollView.subviews as NSArray
        subViews.enumerateObjectsUsingBlock { (obj:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if (idx != index) {
                let temLabel:SXTitleLabel = subViews[idx] as! SXTitleLabel
                temLabel.setScale(0.0)
            }
        }
        
        //添加控制器
        let newsVc:SXTableViewController = self.childViewControllers[index] as! SXTableViewController
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
        
        let subViews:NSArray = self.smallScrollView.subviews as NSArray
        
        let labelLeft:SXTitleLabel = subViews[leftIndex] as! SXTitleLabel
        labelLeft.setScale(CGFloat(scaleLeft))
        
        //考虑到最后一个模块，如果右边已经没有模块了，就不在下面赋值scale了
        if (rightIndex < self.smallScrollView.subviews.count) {
            let labelRight:SXTitleLabel = subViews[rightIndex] as! SXTitleLabel
            labelRight.setScale(CGFloat(scaleRight))
        }
    }
    
    //定位
    func startLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest  //定位精度
        self.locationManager.distanceFilter = 1.0    //距离筛选器
        if #available(iOS 9.0, *) {
            self.locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.NotDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
//            if #available(iOS 9.0, *) {
//                self.locationManager.allowsBackgroundLocationUpdates = true
//            } else {
//                self.locationManager.requestAlwaysAuthorization()
//            }
        }
    }
    
    //locationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("when this delegate run")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (CLlocation != nil) {
            return
        }
        self.locationManager.stopUpdatingLocation()
        print(String(format: "经度%3.5f\n纬度%3.5f", (locations.last?.coordinate.latitude)!,(locations.last?.coordinate.longitude)!) )
        CLlocation = locations.last
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations.last!) { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
            for placemark:CLPlacemark in placemarks! {
                //获取城市
                var city = placemark.locality
                if (city == nil) {
                    //直辖市无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = placemark.administrativeArea
                }
                print("ISO国家编码:\(placemark.ISOcountryCode) \n国家:\(placemark.country) \n省区:\(placemark.administrativeArea) \n城市:\(placemark.locality) \n区域:\(placemark.subLocality) \n街道:\(placemark.thoroughfare) \n详细地址:\(placemark.name)")
                return
            }
        }
    }
    
    //获取天气
    func sendWeatherRequest() {
//        let url = "http://c.3g.163.com/nc/weather/5YyX5LqsfOWMl%2BS6rA%3D%3D.html"
//        SXHTTPManager.shareManager().GET(url, parameters: nil, success: { (operation:AFHTTPRequestOperation?, responseObject:AnyObject?) -> Void in
//            print("responseObject:\(responseObject)")
//            let weatherModel:WeatherModel = WeatherModel(keyValues: responseObject)
//            self.weatherModel = weatherModel
//            self.addWeahter()
//            self.rightItem.hidden = false
//            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
//            print("error:\(error.description)")
//        }
    }
    
    //添加天气
    func addWeahter() {
        let weatherView:WeatherView = WeatherView.view()
        weatherView.setWeather(self.weatherModel!)
        self.weatherView = weatherView
        weatherView.frame = CGRect(x: 0, y: 64, width: mainWidth, height: mainHeight - 64)
        weatherView.alpha = 0.95
        weatherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SXMainViewController.rightItemClick(_:))))
        
        let upView = UIView(frame: CGRectMake(0, 0, mainWidth, 64))
        let tran:UIImageView = UIImageView(image: UIImage(named: "224"))
        tran.frame = CGRect(x: mainWidth - 33, y: 57, width: 7, height: 7)
        upView.addSubview(tran)
        upView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SXMainViewController.rightItemClick(_:))))
        self.upView = upView
        
        let win:UIWindow = (UIApplication.sharedApplication().windows as NSArray).firstObject as! UIWindow
        win.addSubview(weatherView)
        win.addSubview(upView)
        
        self.weatherView?.hidden = true
        self.upView?.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SXMainViewController.pushWeatherDetail), name: "pushWeatherDetail", object: nil)
    }
    
    func pushWeatherDetail() {
        self.rightItemClick("")
    }
    
    @IBAction func rightItemClick(sender: AnyObject) {
        if (self.isWeatherShow == true) {
            self.weatherView?.hidden = true
            self.upView?.hidden = true
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, CGFloat(M_1_PI * 5))
                }, completion: { (finished:Bool) -> Void in
                self.rightItem.setImage(UIImage(named: "top_navigation_square"), forState: UIControlState.Normal)
            })
        } else {
            self.rightItem.setImage(UIImage(named: "223"), forState: UIControlState.Normal)
            self.weatherView?.hidden = false
            self.upView?.hidden = false
            self.weatherView?.addAnimate()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, -CGFloat(M_1_PI * 6))
            }, completion: { (finished:Bool) -> Void in
                self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, CGFloat(M_1_PI))
            })
        }
        self.isWeatherShow = !self.isWeatherShow
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
