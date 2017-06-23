//
//  PraiseCell.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/4/5.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

// 点赞的cell

import UIKit
import RealmSwift

class PraiseCell: UITableViewCell {
    
    let realm = try! Realm()
    var backView: UIView! // 背景视图
    var headView: UIImageView! // 头像视图
    var userName: UILabel! // 点赞人的name

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = appDGrayColor
        
        createUI()
        
    }
    
    func createUI() {
        // 背景视图
        backView = UIView()
        backView.backgroundColor = UIColor.white
        self.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-1)
            make.width.equalTo(boundsWidth)
            make.left.equalTo(0)
            make.height.equalTo(59)
        }
        
        // 头像视图
        headView = UIImageView()
        headView.image = UIImage.init(named: "个人")
        headView.layer.cornerRadius = 20
        headView.layer.borderColor = appDGrayColor.cgColor
        headView.layer.borderWidth = 2
        headView.layer.masksToBounds = true
        self.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(40)
            make.left.equalTo(15)
        }
        
        // 点赞人的name
        userName = UILabel()
        userName.text = "testName"
        self.addSubview(userName)
        userName.snp.makeConstraints { (make) in
            make.left.equalTo(headView.snp.right).offset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
    }
    
    func configerMainPageCell(model:UserInfo) {
        
        if model.image != nil{
            headView.image = UIImage.init(data: model.image as! Data)
        }
        
        userName.text = model.userNickname
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
