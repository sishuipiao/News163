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
    var live_info:String?
    var ads:String?
    var videosource:String?
 
    class func newsModelWithDic(dict:NSDictionary) -> NewsModel {
        var model = NewsModel.alloc()
        model.setValuesForKeysWithDictionary(dict as [NSObject : AnyObject])
        return model
    }
}
