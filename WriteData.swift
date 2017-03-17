//
//  WriteData.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/3/1.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

func writeData() {
    let path = Bundle.main.path(forResource: "mainPage", ofType: "json")
    let jsonData = NSData.init(contentsOfFile: path!)
    let json = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: .mutableContainers) as! [String:Any]
    
    let channels = json["channels"] as! [[String:Any]]
    
    /******************** 网络请求 测试用 ******************
     // 调用API
     let url = URL(string: "http://www.douban.com/j/app/radio/channels")!
     let response = try! Data(contentsOf: url)
     
     // 对 JSON 的回应数据进行反序列化操作
     let json = try! JSONSerialization.jsonObject(with: response,
     options: .allowFragments) as! [String:Any]
     let channels = json["channels"] as! [[String:Any]]
     ******************************************************/
    
    
    
    /******************** 测试豆瓣模型是否能赋值 **********************
     let realm = try! Realm()
     try! realm.write {
     // 为数组中的每一个元素保存一个对象（以及其依赖对象）
     for channel in channels {
     //                if channel["seq_id"] as! Int == 0 {continue} // 第一个频道数据有问题，丢弃
     realm.create(DoubanChannel.self, value: channel, update: true)
     }
     }
     *******************************************/
    
    let realm = try! Realm()
    try! realm.write {
        for channel in channels {
            realm.create(MainPageModel.self, value: channel, update: true)
        }
    }
}
