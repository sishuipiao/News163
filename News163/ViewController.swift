//
//  ViewController.swift
//  News163
//
//  Created by panqiang on 15/7/8.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var arrayList:NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // url  http://c.m.163.com/nc/article/headline/T1348647853363/full.html
        // http://c.m.163.com/nc/article/headline/T1348647853363/0-30.html

        NetworkTools.sharedNetworkTools().GET("nc/article/headline/T1348647853363/0-20.html", parameters: nil, success: { (task, responseObject) -> Void in
            var responseDic = responseObject as! NSDictionary
            var key:String = responseDic.keyEnumerator().nextObject() as! String
            var tempArray:NSArray = responseDic[key] as! NSArray
            //self.writeInfoWithDict(tempArray[1] as! NSDictionary)
            var arrayM = NSMutableArray(capacity: tempArray.count)
            tempArray.enumerateObjectsUsingBlock({ (obj:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                //stop:UnsafeMutablePointer<ObjCBool>  ===> stop.memory ? true:false
                println("====> \(idx) \n====> \(obj) \n====> \(stop.memory) \n")
                var news = NewsModel.newsModelWithDic(obj as! NSDictionary)
                arrayM.addObject(news)
            })
            self.arrayList = arrayM
            },failure : { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
                println("error:\(error.description)")
        }).resume()
    }
    
    func writeInfoWithDict(dic:NSDictionary) {
        var strM:String = ""
        dic.enumerateKeysAndObjectsUsingBlock { (key:AnyObject!, obj:AnyObject!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            println("key:\(key)")
            println("obj:\(obj)")
            let className = NSStringFromClass(obj.classForCoder)
            println("className:\(className)")
            if className == "NSString" || className == "NSConstantString" {
                strM += "property (nonatomic,copy) NSString *\(key as! String);\n"
            }else if className == "NSArray" {
                strM += "property (nonatomic,copy) NSArray *\(key as! String);\n"
            }else if className == "NSNumber" {
                strM += "property (nonatomic,copy) NSNumber *\(key as! String);\n"
            }else if className == "NSBoolean" {
                strM += "property (nonatomic,copy) BOOL *\(key as! String);\n"
            }
            //println("strM:\(strM)")
        }
    }
}

