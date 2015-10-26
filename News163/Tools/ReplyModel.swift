//
//  ReplyModel.swift
//  News163
//
//  Created by panqiang on 15/9/7.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class ReplyModel: NSObject {
    var img:String?
    var name:String?
    var locate:String?
    var time:String?
    var commend:String?
    var up:NSNumber?
    
    override static func replacedKeyFromPropertyName() -> [NSObject : AnyObject]! {
        return ["img":"1.timg","name":"1.n","locate":"1.f","time":"1.t","commend":"1.b","up":"1.v"]
    }
}
