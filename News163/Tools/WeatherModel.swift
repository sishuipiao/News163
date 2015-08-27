//
//  WeatherModel.swift
//  News163
//
//  Created by panqiang on 15/8/26.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
    var detailArray:NSArray!
    var dt:String!
    var rt_temperature:NSNumber!
    
    var nbg1:String!
    var nbg2:String!
    var aqi:NSNumber!
    var pm2_5:NSNumber!

    override static func replacedKeyFromPropertyName() -> [NSObject : AnyObject]! {
        return ["detailArray":"北京|北京",
            "nbg1":"pm2d5.nbg1",
            "nbg2":"pm2d5.nbg2",
            "aqi":"pm2d5.aqi",
            "pm2_5":"pm2d5.pm2_5"]
    }
}
