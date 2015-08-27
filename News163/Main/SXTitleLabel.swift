//
//  SXTitleLabel.swift
//  News163
//
//  Created by panqiang on 15/8/3.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class SXTitleLabel: UILabel {
    
    var scale:CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = NSTextAlignment.Center
        self.font = UIFont.systemFontOfSize(18)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScale(scale:CGFloat) {
        self.scale = scale;
        self.textColor = UIColor(red: scale, green: 0.0, blue: 0.0, alpha: 1)
        var minScale:CGFloat = 0.8
        var trueScale:CGFloat = minScale + (1-minScale)*scale
        self.transform = CGAffineTransformMakeScale(trueScale, trueScale)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
