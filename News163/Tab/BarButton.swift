//
//  BarButton.swift
//  News163
//
//  Created by panqiang on 15/8/27.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class BarButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: (self.width()-20)/2, y: 6, width: 20, height: 20)
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.titleLabel?.setX(self.imageView!.x() - (self.titleLabel!.width() - self.imageView!.width())/2)
        self.titleLabel?.setY(CGRectGetMaxY(self.imageView!.frame)+4)
        
        self.titleLabel?.font = UIFont.systemFontOfSize(12)
        self.titleLabel?.shadowColor = UIColor.clearColor()
        self.titleLabel?.textAlignment = NSTextAlignment.Center
        
        self.highlighted = false
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
