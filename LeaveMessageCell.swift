//
//  LeaveMessageCell.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/4/9.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import RealmSwift

class LeaveMessageCell: UITableViewCell {
    
    var headImage: UIImageView! // 用户头像
    var accountNameLabel: UILabel! // 用户昵称
    var releaseTime: UILabel! // 发布时间
    var contentLabel: UILabel! // 发布内容

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // 给cell赋值方法
    func configerLeaveMessageCell(model: UserMessage) {
        
        // 用户头像图片
        headImage = UIImageView()
        headImage.image = UIImage.init(named: "个人")
        headImage.layer.cornerRadius = 20
        headImage.layer.masksToBounds = true
        headImage.contentMode = .scaleAspectFill
        self.contentView.addSubview(headImage)
        headImage.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.width.height.equalTo(40)
        }
        
        // 用户名字
        accountNameLabel = UILabel()
        accountNameLabel.text = "accountNameLabel"
        self.contentView.addSubview(accountNameLabel)
        accountNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(10)
            make.top.equalTo(10)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        // 发布日期
        releaseTime = UILabel()
        releaseTime.text = "2017-2-27"
        releaseTime.textColor = UIColor.orange
        releaseTime.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(releaseTime)
        releaseTime.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(10)
            make.top.equalTo(accountNameLabel.snp.bottom)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        // 用户内容
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byCharWrapping
        contentLabel.backgroundColor = appDGrayColor
        contentLabel.text = ""
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.equalTo(60)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        
        // 用户头像
        headImage.image = UIImage.init(data: model.currentLeaveHeadImage as! Data)        
//        let userAccount = try! Realm().objects(User.self)
//        for i in userAccount {
//            if model.currentLeaveID == i.userName {
//                if i.userInfo?.image != nil {
//                    headImage.image = UIImage.init(data: i.userInfo?.image as! Data)
//                }
//                break
//            }
//        }
        
        // 用户昵称
        accountNameLabel.text = model.accountNickname
        // 发布时间
        releaseTime.text = model.leaveMessageTime
        // 发布内容
        contentLabel.text = model.accountLeaveMessage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
