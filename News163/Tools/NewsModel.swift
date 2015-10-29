//
//  NewsModel.swift
//  News163
//
//  Created by panqiang on 15/7/14.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class NewsModel: NSObject {
    var tname:String?
    var ptime:String?//新闻发布时间
    var title:String?//标题
    
    var imgextra:NSArray?//多图数组
    var photosetID:String?
    var hasHead:NSNumber?
    var hasImg:NSNumber?
    var lmodify:String?
    var template:String?
    var skipType:String?
    
    var replyCount:NSNumber?//跟帖人数
    var votecount:NSNumber?
    var voteCount:NSNumber?
    var alias:String?
    
    var docid:String?//新闻id
    var hasCover:NSNumber?//bool
    var hasAD:NSNumber?
    var priority:NSNumber?
    var cid:NSNumber?
    var videoID:NSNumber?
    
    var imgsrc:String?//图片连接
    var hasIcon:NSNumber?//bool
    var ename:String?
    var skipID:String?
    var order:NSNumber?
    
    var digest:String?//描述
    var editor:NSArray?
    
    var url_3w:String?
    var specialID:String?
    var timeConsuming:String?
    var subtitle:String?
    var adTitle:String?
    var url:String?
    var source:String?
    
    var TAGS:String?
    var TAG:String?
    
    var imgType:NSNumber?//大图样式
    var specialextra:NSArray?
    
    var boardid:String?
    var commentid:String?
    var speciallogo:NSNumber?
    var specialtip:String?
    var specialadlogo:String?
    
    var pixel:String?
    var applist:NSArray?
    
    var wap_portal:String?
    var live_info:LiveInfoModel?
    var ads:NSArray?
    var videosource:String?
 
    class func newsModelWithDic(dict:NSDictionary) -> NewsModel {
        let model = NewsModel()
        model.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
        return model
    }
    
    override static func objectClassInArray() -> [NSObject : AnyObject]! {
        return ["ads":"AdsModel"]
    }
}

class AdsModel: NSObject {
    var imgsrc:String?  //图片url地址
    var subtitle:String? //详情
    var tag:String?   //标志
    var title:String?  //标题
    var url:String?  //连接
}

class LiveInfoModel:NSObject {
    var end_time:String?
    var roomId:String?
    var start_time:String?
    
    var type:NSNumber?
    var user_count:NSNumber?
    var video:NSNumber?
}
