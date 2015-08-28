//
//  Tools.swift
//  News163
//
//  Created by panqiang on 15/8/28.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class Tools: NSObject {
    //纯色Image
    class func createImageWithColor(color:UIColor) ->UIImage {
        var rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        var theimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theimage
    }
}
