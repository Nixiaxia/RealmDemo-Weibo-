//
//  Model_1.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/2/7.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import Foundation
import RealmSwift

// 账户详情
class UserInfo: Object {
    // 用户昵称
    dynamic var userNickname = ""
    // 用户头像
    dynamic var image: NSData? = nil
}

// 账户
class User: Object {
    // 账户
    dynamic var userName = ""
    // 密码
    dynamic var passWord = ""
    
    dynamic var userInfo: UserInfo?
    
}

// 默认登录
class SaveAccount: Object {
    // 储存 用户？先试试...
    dynamic var saveAccount = ""
    
//    override static func primaryKey() -> String? {
//        return "saveAccount"
//    }
}

// 豆瓣频道 测试...
//class DoubanChannel: Object {
//    // 频道id
//    dynamic var channel_id = ""
//    // 频道名称
//    dynamic var name = ""
//    // 频道英文名称
//    dynamic var name_en = ""
//    // 排序
//    dynamic var seq_id = 0
//    dynamic var abbr_en = ""
//    
//    //设置主键
//    override static func primaryKey() -> String? {
//        return "channel_id"
//    }
//}

// 主页Model
class MainPageModel: Object {
    // 账户昵称
    dynamic var accountName = ""
    // 账户头像
    dynamic var accountImage = ""
    // 发布时间
    dynamic var time = ""
    // 发布内容
    dynamic var content = ""
    // 点赞数量
    dynamic var praiseNumber = 0
    // 是否点赞
    dynamic var praiseFalse = false
    // 用户头像
    dynamic var image: NSData? = nil
    // 点赞的人
    let praisePeople = List<PraisePeople>()
    // 留言
    let leaveMessage = List<UserMessage>()
    // 上传的图片
    let mainPagePhotos = List<MainPagePhotos>()
    
//    override static func primaryKey() -> String? {
//        return "accountName"
//    }
}

// 主页cell中的图片
class MainPagePhotos: Object {
    dynamic var image: NSData? = nil
}

// 主页cell中的留言
class UserMessage: Object {
    // 留言账户昵称
    dynamic var accountNickname = ""
    // 留言
    dynamic var accountLeaveMessage = ""
    
}

// 主页cell点赞的人
class PraisePeople: Object {
    // 点赞人的账号
    dynamic var  praiseName = ""
    
}





