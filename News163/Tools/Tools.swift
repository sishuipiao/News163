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
    //string转nsdate
    class func dateFromString(str:String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date = dateFormatter.dateFromString(str)
        return date!
    }
    //转MM-dd HH:mm
    class func mmddHHmmFromDate(date:NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        var str = dateFormatter.stringFromDate(date)
        return str
    }
}
