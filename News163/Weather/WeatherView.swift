//
//  WeatherView.swift
//  News163
//
//  Created by panqiang on 15/8/26.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    @IBOutlet weak var nowTempLabel: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var climateLbl: UILabel!
    @IBOutlet weak var localLbl: UILabel!
    @IBOutlet weak var dateWeekLbl: UILabel!
    @IBOutlet weak var airPMLbl: UILabel!
    
    var bottomView:UIView!
    
    var btn1:UIButton!
    var btn2:UIButton!
    var btn3:UIButton!
    var btn4:UIButton!
    var btn5:UIButton!
    var btn6:UIButton!
    
    var img1:UIImageView!
    var img2:UIImageView!
    var img3:UIImageView!
    var img4:UIImageView!
    var img5:UIImageView!
    var img6:UIImageView!

    var weatherModel:WeatherModel?
    
    class func view() -> WeatherView {
        return (NSBundle.mainBundle().loadNibNamed("WeatherView", owner: nil, options: nil) as NSArray).firstObject as! WeatherView
    }
    
    override func awakeFromNib() {
        var bottomView = UIView()
        self.bottomView = bottomView
        self.addSubview(bottomView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bottomView.frame = CGRect(x: 0, y: 255, width: self.width(), height: self.height() - 255)
        
        self.addBtnWithTitle("搜索", icon: "204", color: UIColor.orangeColor(), index: 0);
        self.addBtnWithTitle("上头条", icon: "202", color: UIColor.redColor(), index: 1);
        self.addBtnWithTitle("离线", icon: "203", color: UIColor(red: 213/255.0, green: 22/255.0, blue: 71/255.0, alpha: 1), index: 2);
        self.addBtnWithTitle("夜间", icon: "205", color:UIColor(red: 58/255.0, green: 153/255.0, blue: 208/255.0, alpha: 1), index: 3);
        self.addBtnWithTitle("扫一扫", icon: "204", color:UIColor(red: 70/255.0, green: 95/255.0, blue: 176/255.0, alpha: 1), index: 4);
        self.addBtnWithTitle("邀请好友", icon: "201", color:UIColor(red: 80/255.0, green: 192/255.0, blue: 70/255.0, alpha: 1), index: 5);
    }
    
    func addBtnWithTitle(title:String, icon:String, color:UIColor, index:Int) {
        let cols:Int = index%3
        let rows:Int = index/3
        let w:CGFloat = self.width()/3
        let h:CGFloat = self.bottomView.height()/2
        var itemView = UIView(frame: CGRect(x: CGFloat(cols) * w, y: CGFloat(rows) * h, width: w, height: h))
        self.bottomView.addSubview(itemView)
        
        var btn = UIButton(frame: CGRect(x: 20, y: index > 2 ? 10 : 40, width: w-40, height: w-40))
        btn.layer.cornerRadius = (w-40)/2
        btn.backgroundColor = color
        itemView.addSubview(btn)
        
        var img = UIImageView(image: UIImage(named: icon))
        img.setWidth(w-40)
        img.setHeight(w-40)
        img.center = btn.center
        itemView.addSubview(img)
        
        var titleLabel = UILabel()
        titleLabel.setHeight(40)
        titleLabel.setWidth(itemView.width())
        titleLabel.setX(0)
        titleLabel.setY(btn.y() + btn.height())
        titleLabel.font = UIFont(name: "HYQiHei", size: 16)
        titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.Center
        itemView.addSubview(titleLabel)
        
        switch index {
            case 0: self.btn1 = btn;self.img1 = img; break
            case 1: self.btn2 = btn;self.img2 = img; break
            case 2: self.btn3 = btn;self.img3 = img; break
            case 3: self.btn4 = btn;self.img4 = img; break
            case 4: self.btn5 = btn;self.img5 = img; break
            default: self.btn6 = btn;self.img6 = img; break
        }
        
    }
    
    func addAnimate() {
        self.btn1.transform = CGAffineTransformMakeScale(0.2, 0.2)
        self.btn2.transform = CGAffineTransformMakeScale(0.2, 0.2)
        self.btn3.transform = CGAffineTransformMakeScale(0.2, 0.2)
        self.btn4.transform = CGAffineTransformMakeScale(0.2, 0.2)
        self.btn5.transform = CGAffineTransformMakeScale(0.2, 0.2)
        self.btn6.transform = CGAffineTransformMakeScale(0.2, 0.2)
        
        self.img1.transform = CGAffineTransformMakeScale(1.4, 1.4)
        self.img2.transform = CGAffineTransformMakeScale(1.4, 1.4)
        self.img3.transform = CGAffineTransformMakeScale(1.4, 1.4)
        self.img4.transform = CGAffineTransformMakeScale(1.4, 1.4)
        self.img5.transform = CGAffineTransformMakeScale(1.4, 1.4)
        self.img6.transform = CGAffineTransformMakeScale(1.4, 1.4)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.btn1.transform = CGAffineTransformMakeScale(1.2, 1.2)
            self.btn2.transform = CGAffineTransformMakeScale(1.2, 1.2)
            self.btn3.transform = CGAffineTransformMakeScale(1.2, 1.2)
            self.btn4.transform = CGAffineTransformMakeScale(1.2, 1.2)
            self.btn5.transform = CGAffineTransformMakeScale(1.2, 1.2)
            self.btn6.transform = CGAffineTransformMakeScale(1.2, 1.2)
            
            self.img1.transform = CGAffineTransformMakeScale(0.7, 0.7)
            self.img2.transform = CGAffineTransformMakeScale(0.7, 0.7)
            self.img3.transform = CGAffineTransformMakeScale(0.7, 0.7)
            self.img4.transform = CGAffineTransformMakeScale(0.7, 0.7)
            self.img5.transform = CGAffineTransformMakeScale(0.7, 0.7)
            self.img6.transform = CGAffineTransformMakeScale(0.7, 0.7)
            }) { (finished:Bool) -> Void in
                self.btn1.transform = CGAffineTransformIdentity
                self.btn2.transform = CGAffineTransformIdentity
                self.btn3.transform = CGAffineTransformIdentity
                self.btn4.transform = CGAffineTransformIdentity
                self.btn5.transform = CGAffineTransformIdentity
                self.btn6.transform = CGAffineTransformIdentity
                
                self.img1.transform = CGAffineTransformIdentity
                self.img2.transform = CGAffineTransformIdentity
                self.img3.transform = CGAffineTransformIdentity
                self.img4.transform = CGAffineTransformIdentity
                self.img5.transform = CGAffineTransformIdentity
                self.img6.transform = CGAffineTransformIdentity
        }

    }

    @IBAction func pushDetail(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("pushWeatherDetail", object: nil)
    }
    
    func setWeather(model:WeatherModel) {
        self.nowTempLabel.text = "\(model.rt_temperature)"
        let weatherDetail:WeatherDetail = WeatherDetail(keyValues: model.detailArray.objectAtIndex(0))
        
        var temp:NSMutableString = weatherDetail.temperature.mutableCopy() as! NSMutableString
        temp.replaceOccurrencesOfString("C", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, temp.length))
        
        self.tempLbl.text = temp as String
        self.dateWeekLbl.text = String(format: "%@  %@", model.dt,weatherDetail.week)
        var desc:String
        let pm = model.pm2_5.integerValue
        if (pm < 50) {
            desc = "优"
        }else if (pm < 100) {
            desc = "良"
        }else {
            desc = "差"
        }
        
        self.airPMLbl.text = String(format: "PM2.5  %d  %@", pm,desc)
        self.localLbl.text = "北京"
        self.climateLbl.text = String(format: "%@ %@", weatherDetail.climate,weatherDetail.wind)
        
        if weatherDetail.climate == "雷阵雨" {
            self.weatherImg.image = UIImage(named: "thunder_mini")
        }else if weatherDetail.climate == "晴" {
            self.weatherImg.image = UIImage(named: "sun_mini")
        }else if weatherDetail.climate == "多云" {
            self.weatherImg.image = UIImage(named: "sun_and_cloud_mini")
        }else if weatherDetail.climate == "阴" {
            self.weatherImg.image = UIImage(named: "nosun_mini")
        }else if weatherDetail.climate == "雨" {
            self.weatherImg.image = UIImage(named: "rain_mini")
        }else if weatherDetail.climate == "雪" {
            self.weatherImg.image = UIImage(named: "snow_heavyx_mini")
        }else {
            self.weatherImg.image = UIImage(named: "sand_float_mini")
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
