//
//  DetailModel.swift
//  News163
//
//  Created by panqiang on 15/9/2.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class DetailModel: NSObject {
    var replyCount:NSNumber? //回帖数
    var title:String?   //新闻标题
    var ptime:String?   //发布时间
    var source:String?  //来源
    
    var digest:String?  //简介
    var img:NSArray?    //新闻配图
    var dkeys:String?   //图片下文字
    
    var body:String?    //新闻内容
    
    var keyword_search:NSArray?  //相关新闻关键字     //key = "word"
    var relative_sys:NSArray?    //相关新闻
    var topiclist:NSArray?       //订阅源推荐
    
    override static func objectClassInArray() -> [NSObject : AnyObject]! {
        return ["img":"DetailImgModel"]
    }
}

class DetailImgModel: NSObject{
    var alt:String?         //图片简介
    var photosetID:String?  //图片id
    var pixel:String?       //图片尺寸
    var ref:String?         //图片所在位置
    var src:String?         //图片url
}

class DetailRelativeModel: NSObject {
    var ID:String?
    var title:String?
    var imgsrc:String?
    var source:String?
    var ptime:String?
    var type:String?
    
    override static func replacedKeyFromPropertyName() -> [NSObject : AnyObject]! {
        return ["ID":"id"]
    }
}

class DetailtopiclistModel: NSObject {
    var tname:String?       //大标题
    var alias:String?       //简介
    
}
