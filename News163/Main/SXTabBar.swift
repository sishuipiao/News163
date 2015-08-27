//
//  SXTabBar.swift
//  News163
//
//  Created by panqiang on 15/8/25.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class SXTabBar: UIView {
    
    var delegate:SXTabBarDelegate?
    var selButton:SXBarButton?
    var imgView:UIImageView?
    
    func addImageView() {
        var imgView = UIImageView(image: UIImage(named: ""))
        self.imgView = imgView
        self.addSubview(imgView)
    }
    
    //传入数据赋值button图片
    func addBarButtonWithNorName(nor:String, dis:String, title:String) {
        var btn = SXBarButton()
        btn.setImage((UIImage(named: nor)), forState: UIControlState.Normal)
        btn.setImage((UIImage(named: dis)), forState: UIControlState.Disabled)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor(red: 149/255.0, green: 149/255.0, blue: 149/255.0, alpha: 1), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor(red: 183/255.0, green: 20/255.0, blue: 28/255.0, alpha: 1), forState: UIControlState.Disabled)
        btn.addTarget(self, action: "btnClick:", forControlEvents: UIControlEvents.TouchDown)
        self.addSubview(btn)
        if (self.subviews.count == 2) {
            btn.tag = 1
            self.btnClick(btn)
        }
    }
    
    func btnClick(btn:SXBarButton) {
        if (self.delegate!.respondsToSelector("changSelIndexForm")) {
            self.delegate?.changSelIndexForm(self.selButton!.tag, to: btn.tag)
        }
        self.selButton?.enabled = true
        self.selButton = btn
        btn.enabled = false
    }
    
    //动态加载时设置frame
    override func layoutSubviews() {
        var imgView:UIImageView = self.subviews[0] as! UIImageView
        imgView.frame = self.bounds
        for index in 1...self.subviews.count {
            var btn:UIButton = self.subviews[index] as! UIButton
            btn.frame = CGRect(x: (index - 1)*Int(mainWidth/5), y: 0, width: Int(mainWidth/5), height: 49)
            btn.tag = index - 1;
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

protocol SXTabBarDelegate:NSObjectProtocol {
    func changSelIndexForm(from:NSInteger, to:NSInteger)
}


