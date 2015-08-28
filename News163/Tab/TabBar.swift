//
//  TabBar.swift
//  News163
//
//  Created by panqiang on 15/8/27.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class TabBar: UIView {
    
    var delegate:TabBarDelegate?
    var selButton:BarButton?
    var imgView:UIImageView?
    
    override func layoutSubviews() {
        var imgView:UIImageView = self.subviews[0] as! UIImageView
        imgView.frame = self.bounds
        
        for index in 1...self.subviews.count - 1 {
            var btn:UIButton = self.subviews[index] as! UIButton
            btn.frame = CGRect(x: CGFloat(index - 1) * mainWidth/5, y: 0, width: mainWidth/5, height: 49)
            btn.tag = index - 1
        }
    }
    
    func addImageView() {
        var imgView = UIImageView()
        self.imgView = imgView
        self.addSubview(imgView)
    }
    
    func addBarButton(nor:String, dis:String, title:String) {
        var btn = BarButton()
        
        btn.setImage(UIImage(named: nor), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: dis), forState: UIControlState.Disabled)
        
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor(red: 133/255.0, green: 133/255.0, blue: 133/255.0, alpha: 1), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor(red: 223/255.0, green: 48/255.0, blue: 49/255.0, alpha: 1), forState: UIControlState.Disabled)
        
        btn.addTarget(self, action: "btnClick:", forControlEvents: UIControlEvents.TouchDown)
        self.addSubview(btn)
        
        if (self.subviews.count == 2) {
            btn.tag = 1
            self.btnClick(btn)
        }
    }
    
    func btnClick(btn:BarButton) {
        if (self.selButton == nil) {
            self.delegate?.ChangSelIndex(0, to: btn.tag)
        }else{
            self.delegate?.ChangSelIndex(self.selButton!.tag, to: btn.tag)
            self.selButton!.enabled = true
        }
        self.selButton = btn
        btn.enabled = false
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

protocol TabBarDelegate:NSObjectProtocol {
    func ChangSelIndex(from:Int, to:Int)
}
