//
//  NetworkTools.swift
//  News163
//
//  Created by panqiang on 15/7/8.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class NetworkTools: AFHTTPSessionManager {
    class func sharedNetworkTools() ->NetworkTools {
        var instance = NetworkTools()
        var onceToken = dispatch_once_t()
        dispatch_once(&onceToken, { () -> Void in
            
            // http://c.m.163.com//nc/article/list/T1348649654285/0-20.html
            // http://c.m.163.com/photo/api/set/0096/57255.json
            // http://c.m.163.com/photo/api/set/54GI0096/57203.html
            
            let url = NSURL(string: "http://c.m.163.com/")!
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            instance = NetworkTools(baseURL: url, sessionConfiguration: config)
            instance.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/html") as Set<NSObject>
        })
        return instance
    }
}
