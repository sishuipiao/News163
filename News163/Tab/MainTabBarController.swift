//
//  MainTabBarController.swift
//  News163
//
//  Created by panqiang on 15/8/27.
//  Copyright (c) 2015年 panqiang. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController,TabBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        var tabBar:TabBar = TabBar()
        tabBar.frame = self.tabBar.bounds
        tabBar.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        self.tabBar.addSubview(tabBar)
        
        tabBar.delegate = self
        tabBar.addImageView()
        
        tabBar.addBarButton("tabbar_icon_news_normal", dis: "tabbar_icon_news_highlight", title: "新闻")
        tabBar.addBarButton("tabbar_icon_reader_normal", dis: "tabbar_icon_reader_highlight", title: "阅读")
        tabBar.addBarButton("tabbar_icon_media_normal", dis: "tabbar_icon_media_highlight", title: "视听")
        tabBar.addBarButton("tabbar_icon_found_normal", dis: "tabbar_icon_found_highlight", title: "发现")
        tabBar.addBarButton("tabbar_icon_me_normal", dis: "tabbar_icon_me_highlight", title: "我")
        
        self.selectedIndex = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ChangSelIndex(from: Int, to: Int) {
        self.selectedIndex = to
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
