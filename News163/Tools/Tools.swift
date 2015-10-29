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
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let theimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theimage
    }
    //string转nsdate
    class func dateFromString(str:String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.dateFromString(str)
        return date!
    }
    //转MM-dd HH:mm
    class func mmddHHmmFromDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let str = dateFormatter.stringFromDate(date)
        return str
    }
    class func filterNBSP(html:String) -> String {
        let nsstr:NSString = html
        let range:NSRange = nsstr.rangeOfString("&nbsp;")
        if range.location == NSNotFound {
            return html
        }
        return nsstr.substringToIndex(range.location)
    }
    //计算label高度
    class func getHeight(str:String, wid:CGFloat, fnt:UIFont) -> CGFloat {
        let string:NSString = str
        let sizeToFit = string.boundingRectWithSize(CGSize(width: wid, height: 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:fnt], context: nil)
        let nameH = CGFloat(sizeToFit.height/fnt.pointSize) * 2
        return nameH
    }
}
