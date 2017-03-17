//
//  CurrentID.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/3/3.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import Foundation
import RealmSwift

public func currentUserID() -> String { // 获取当前登陆用户ID
    
    var currentID = SaveAccount()
    
    let saveAccount = try! Realm().objects(SaveAccount.self)
    for i in 0..<1 {
        currentID = saveAccount[i]
    }
    
    return currentID.saveAccount
}

public func currentUserNickname() -> String { // 获取当前登陆用户昵称
    
    var currentID = SaveAccount()
    
    let saveAccount = try! Realm().objects(SaveAccount.self)
    
    currentID = saveAccount.first!
    
    let userID = try! Realm().objects(User.self)
    var currentIdNickname = ""
    for i in 0..<userID.count {
        if userID[i].userName == currentID.saveAccount {
            currentIdNickname = (userID[i].userInfo?.userNickname)!
        }
    }
    return currentIdNickname
}

public func currentUserImage() -> NSData { // 获取当前用户头像
    
    var currentID = SaveAccount()
    
    var userImage = NSData()
    
    let saveAccount = try! Realm().objects(SaveAccount.self)
    
    currentID = saveAccount.first!
    
    let user = try! Realm().objects(User.self)
    
    for i in 0..<user.count {
        if user[i].userName == currentID.saveAccount {
            if user[i].userInfo?.image != nil {
                userImage = (user[i].userInfo?.image)!
            }else {
                userImage = UIImagePNGRepresentation(UIImage.init(named: "个人")!)! as NSData
            }
        }
    }
    return userImage
}











