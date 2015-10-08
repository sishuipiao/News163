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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // url  http://c.m.163.com/nc/article/headline/T1348647853363/full.html
        // http://c.m.163.com/nc/article/headline/T1348647853363/0-30.html
        
        NetworkTools.sharedNetworkTools().GET("nc/article/headline/T1348647853363/0-20.html", parameters: nil, success: { (task:NSURLSessionDataTask!, responseObject:AnyObject!) -> Void in
            let responseDic:NSDictionary = responseObject as! NSDictionary
            let key:String = responseDic.keyEnumerator().nextObject() as! String
            let tempArray:NSArray = responseDic[key] as! NSArray
            //self.writeInfoWithDict(tempArray[1] as! NSDictionary)
            let arrayM = NSMutableArray(capacity: tempArray.count)
            tempArray.enumerateObjectsUsingBlock({ (obj:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                //stop:UnsafeMutablePointer<ObjCBool>  ===> stop.memory ? true:false
                print("====> \(idx) \n====> \(obj) \n====> \(stop.memory) \n")
                let news = NewsModel.newsModelWithDic(obj as! NSDictionary)
                arrayM.addObject(news)
            })
            self.arrayList = arrayM
            },failure : { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
                print("error:\(error.description)")
        })!.resume()

    }
    
    func writeInfoWithDict(dic:NSDictionary) {
        var strM:String = ""
        dic.enumerateKeysAndObjectsUsingBlock { (key:AnyObject!, obj:AnyObject!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            print("key:\(key)")
            print("obj:\(obj)")
            let className = NSStringFromClass(obj.classForCoder)
            print("className:\(className)")
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

