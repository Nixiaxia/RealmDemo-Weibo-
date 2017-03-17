//
//  MainPageCell.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/2/27.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import Lightbox

class MainPageCell: UITableViewCell {
    var headImage: UIImageView! // 用户头像
    var accountNameLabel: UILabel! // 用户昵称
    var releaseTime: UILabel! // 发布时间
    var contentLabel: UILabel! // 发布内容
    var accountImages: UICollectionView! // 图片
    var layout: UICollectionViewFlowLayout! // 图片大小
    
    var commentButton: UIButton! // 评论按钮
    var praiseButton: UIButton! // 点赞按钮
    
    var commentNumber = 0 // 评论数量
    var praiseNumber = 0 // 点赞数量
    var praiseFalse = false // 判断点赞或者取消
    
    var mainPageModel: MainPageModel!
    
    var praiseClickBack: ((Int,Bool) -> ())? // 点赞闭包传值
    var commentClickBack: (()->())? // 评论按钮闭包
    
    var images = [UIImage]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    // 点赞点击事件
    func praiseButtonAction(sender: UIButton) {
        
        if praiseFalse == false {
            praiseButton.setImage(UIImage.init(named: "点赞-2"), for: .normal)
            praiseButton.setTitleColor(UIColor.orange, for: .normal)
            praiseNumber += 1
            praiseButton.setTitle(" \(praiseNumber)", for: .normal)
            praiseFalse = true
            
            // 闭包传值
            praiseClickBack!(praiseNumber,praiseFalse)
            
        }else {
            praiseButton.setImage(UIImage.init(named: "点赞"), for: .normal)
            praiseButton.setTitleColor(UIColor.darkGray, for: .normal)
            praiseNumber -= 1
            praiseButton.setTitle(" \(praiseNumber)", for: .normal)
            praiseFalse = false
            
            // 闭包传值
            praiseClickBack!(praiseNumber,praiseFalse)
        }
    }
    
    // 评论点击事件
    func commentButtonAction(sender: UIButton) {
        commentClickBack!()
    }
    
    // 给cell赋值方法
    func configerMainPageCell(model: MainPageModel) {
        
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
        contentLabel.text = ""
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            //            make.bottom.equalTo(-10)
        }
        
        // 照片
        layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: (boundsWidth - 20 - 10)/3, height: (boundsWidth - 20 - 10)/3)
        layout.minimumLineSpacing = 5 // 最小行间距
        layout.minimumInteritemSpacing = 5 // 最小列间距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0) // 设置边距
        
        accountImages = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        accountImages.backgroundColor = UIColor.white
        accountImages.isScrollEnabled = false
//        accountImages.collectionViewLayout = layout
        
        accountImages.register(MainPageCollectionCell.self, forCellWithReuseIdentifier: "MainPageCollectionCell")
        
        accountImages.delegate = self
        accountImages.dataSource = self
        
        self.contentView.addSubview(accountImages)
        accountImages.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
//            make.width.equalTo(0)
//            make.height.equalTo(400)
            make.centerX.equalTo(self.snp.centerX).offset(0)
        }
        
        // 底部一层view
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        self.contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(accountImages.snp.bottom).offset(10)
            make.width.equalTo(boundsWidth)
            make.centerX.equalTo(self.snp.centerX).offset(0)
            make.height.equalTo(40)
            make.bottom.equalTo(0)
        }
        
        // 按钮上面的一条线
        let lineLabel = UILabel()
        lineLabel.backgroundColor = appDGrayColor
        bottomView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(1)
        }
        
        // 评论按钮
        commentButton = UIButton()
        commentButton.setTitle(" \(commentNumber)", for: .normal)
        commentButton.setTitleColor(UIColor.darkGray, for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        commentButton.setImage(UIImage.init(named: "评论"), for: .normal)
        bottomView.addSubview(commentButton)
        commentButton.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(1)
            make.width.equalTo(boundsWidth/2)
            make.height.equalTo(29)
        }
        commentButton.addTarget(self, action: #selector(commentButtonAction(sender:)), for: .touchUpInside)
        
        // 按钮之间的一条竖线
        let verticalLineLabel = UILabel()
        verticalLineLabel.backgroundColor = appDGrayColor
        bottomView.addSubview(verticalLineLabel)
        verticalLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(1)
            make.left.equalTo(commentButton.snp.right)
            make.height.equalTo(29)
        }
        
        // 点赞按钮
        praiseButton = UIButton()
        praiseButton.setTitle(" \(praiseNumber)", for: .normal)
        praiseButton.setTitleColor(UIColor.darkGray, for: .normal)
        praiseButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        praiseButton.setImage(UIImage.init(named: "点赞"), for: .normal)
        bottomView.addSubview(praiseButton)
        praiseButton.snp.makeConstraints { (make) in
            make.left.equalTo(commentButton.snp.right).offset(1)
            make.top.equalTo(1)
            make.width.equalTo(boundsWidth/2 - 1)
            make.height.equalTo(29)
        }
        praiseButton.addTarget(self, action: #selector(praiseButtonAction(sender:)), for: .touchUpInside)
        praiseButton.tag = 11
        
        // cell底部一条横线
        let bottomLine = UILabel()
        bottomLine.backgroundColor = appDGrayColor
        bottomView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(commentButton.snp.bottom)
            make.height.equalTo(10)
            make.width.equalTo(boundsWidth)
        }

        mainPageModel = model
        
        // 用户头像
        headImage.image = UIImage.init(data: model.image as! Data)
        // 用户昵称
        accountNameLabel.text = model.accountName
        // 发布时间
        releaseTime.text = model.time
        // 发布内容
        contentLabel.text = model.content
        // 评论数量
        commentNumber = model.leaveMessage.count
        commentButton.setTitle(" \(commentNumber)", for: .normal)
        // 点赞数量
        praiseNumber = model.praiseNumber
        praiseButton.setTitle(" \(praiseNumber)", for: .normal)
        
        // 判断是否点赞
        if model.praiseFalse {
            praiseButton.setImage(UIImage.init(named: "点赞-2"), for: .normal)
            praiseButton.setTitleColor(UIColor.orange, for: .normal)
            praiseFalse = true
        }else {
            praiseButton.setImage(UIImage.init(named: "点赞"), for: .normal)
            praiseButton.setTitleColor(UIColor.darkGray, for: .normal)
            praiseFalse = false
        }
        
        // 图片的处理
        let itemCount = model.mainPagePhotos.count
        
        if itemCount == 0 {
            accountImages.snp.makeConstraints({ (make) in
                make.height.equalTo(0)
            })
        }else if itemCount == 1 || itemCount == 2 || itemCount == 3 {
            accountImages.snp.makeConstraints({ (make) in
                make.height.equalTo((boundsWidth - 20 - 10)/3)
            })
        }else if itemCount == 4 || itemCount == 5 || itemCount == 6 {
            accountImages.snp.makeConstraints({ (make) in
                make.height.equalTo(((boundsWidth - 20 - 10)/3)*2)
            })
        }else if itemCount == 7 || itemCount == 8 || itemCount == 9 {
            accountImages.snp.makeConstraints({ (make) in
                make.height.equalTo(((boundsWidth - 20 - 10)/3)*3)
            })
        }
        
        accountImages.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MainPageCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainPageModel.mainPagePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = mainPageModel.mainPagePhotos[indexPath.item]
        
        let cell: MainPageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageCollectionCell", for: indexPath) as! MainPageCollectionCell
        
        cell.imageBlock = {
            for i in self.mainPageModel.mainPagePhotos {
                self.images.append(UIImage.init(data: i.image as! Data)!)
            }
            let lightboxImages = self.images.map {
                return LightboxImage.init(image: $0)
            }
            let lightbox = LightboxController.init(images: lightboxImages, startIndex: indexPath.item)
            lightbox.dismissalDelegate = self
            self.jk_viewController.present(lightbox, animated: true, completion: nil)
        }
        
        cell.configModel(model: model)
        
        return cell
    }
}

extension MainPageCell: LightboxControllerDismissalDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        self.images.removeAll()
    }
}
