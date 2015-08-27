//
//  SXNavController.swift
//  News163
//
//  Created by panqiang on 15/8/3.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class SXNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override class func initialize() {
        var navBar:UINavigationBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.redColor();
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
