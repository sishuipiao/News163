//
//  SXHTTPManager.swift
//  News163
//
//  Created by panqiang on 15/8/25.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class SXHTTPManager: AFHTTPRequestOperationManager {
    class func shareManager() -> SXHTTPManager {
        let mgr:SXHTTPManager = SXHTTPManager(baseURL: nil)
        let mgrSet = NSMutableSet()
        mgrSet.setSet(mgr.responseSerializer.acceptableContentTypes!)
        mgrSet.addObject("text/html")
        mgr.responseSerializer.acceptableContentTypes = mgrSet as Set<NSObject>
        return mgr
    }
}
