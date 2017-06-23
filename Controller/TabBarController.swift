//
//  TabBarControllerViewController.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/2/6.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var userAccount: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        configureViewControllers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectIndex), name: NSNotification.Name(rawValue: "SelectIndex"), object: nil)
    }
    
    func selectIndex() {
        self.selectedIndex = 0        
    }
    
    func configureViewControllers() {
        
        // 如果新建一个控制器，需要什么东西
        let vcInfos = [
            [
                "title": "首页",
                "image": "首页-首页",
                "imageSelect": "首页-首页-2",
                "class": "RealmDemo.MainPageVC",
                ],
            [
                "title": "发动态",
                "image": "加号",
                "imageSelect": "",
                "class": "RealmDemo.WritePageVC",
                ],
            [
                "title": "我的",
                "image": "我的",
                "imageSelect": "我的-2",
                "class": "RealmDemo.MinePageVC",
                ],
            ]
        
        var vcArr: [UINavigationController] = []
        
        for vcInfo in vcInfos {
            // swift中，通过字符串获取一个类，需要在类名前加上工程名，还需要将类强转一下
            let vc = (NSClassFromString(vcInfo["class"]!) as! UIViewController.Type).init()
            vc.navigationItem.title = vcInfo["title"]
//            vc.title = vcInfo["title"]
            
            let navVC = UINavigationController.init(rootViewController: vc)
            navVC.tabBarItem.title = vcInfo["title"]
            vcArr.append(navVC)
        }
        
        self.viewControllers = vcArr
        
        var i = 0
        // 设置 tabBar 按钮图片
        for tabBarItem in self.tabBar.items! {
            tabBarItem.image = UIImage.init(named: vcInfos[i]["image"]!)
            if i == 1 {
                tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            }else {
                tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            }
            tabBarItem.selectedImage = UIImage.init(named: vcInfos[i]["imageSelect"]!)
            i = i + 1
        }     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
