//
//  MainPageCellDetails.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/3/14.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import Lightbox
import RealmSwift

class MainPageCellDetails: UIViewController {
    
    let realm = try! Realm()
    
    var item = MainPageModel() // 接收上个页面的值
    
    var offset = Int() // 偏移量
    
    var commentOrDidSelect = false
    
    var tableView: UITableView! // 评论和点赞的tableView
    
    var accountImages: UICollectionView! // 图片collectionView
    
    var images = [UIImage]() // 保存取出来的照片
    
    var commentButton: UIButton! // 评论按钮
    var praiseButton: UIButton! // 赞按钮
    
    var lineLabel: UILabel! // 底部横线动画
    
    var chooseLeaveMessage = true // 默认选择是评论
    
    var praiseBottomButton: UIButton! // 底部右边点赞按钮
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = appDGrayColor
        self.title = "正文"
        
        createUI()
 
    }
    
    func createUI() {
        
        // 底层tableview
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.frame = self.view.bounds
        tableView.separatorStyle = .none

        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LeaveMessageCell.self, forCellReuseIdentifier: "LeaveMessageCell")
        tableView.register(PraiseCell.self, forCellReuseIdentifier: "praiseCell")
        
        self.view.addSubview(tableView)
        
        // tableView上的headView
        let headView = UIView()
        headView.backgroundColor = UIColor.white
        headView.frame = CGRect.init(x: 0, y: 0, width: boundsWidth, height: 200)
        tableView.tableHeaderView = headView
        
        // 底部View
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(50)
        }
        
        // 底部View上面的一条横线
        let bottomsTopLine = UILabel()
        bottomsTopLine.backgroundColor = appDGrayColor
        bottomView.addSubview(bottomsTopLine)
        bottomsTopLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(bottomView.snp.centerX)
            make.height.equalTo(2)
            make.width.equalTo(boundsWidth)
        }
        
        // 底部View左边评论
        let leaveMessageButton = UIButton()
        leaveMessageButton.setTitle(" 评论", for: .normal)
        leaveMessageButton.setTitleColor(UIColor.darkGray, for: .normal)
        leaveMessageButton.setImage(UIImage.init(named: "评论"), for: .normal)
//        leaveMessageButton.backgroundColor = appDGrayColor
        bottomView.addSubview(leaveMessageButton)
        leaveMessageButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView.snp.centerY)
            make.width.equalTo((boundsWidth - 1)/2)
            make.height.equalTo(48)
            make.bottom.equalTo(0)
            make.centerX.equalTo(bottomView.snp.centerX).offset(-(boundsWidth/4)-1)
        }
        leaveMessageButton.addTarget(self, action: #selector(leaveMessageButtonAction), for: .touchUpInside)
        
        // 中间竖杠
        let verticalLine = UILabel()
        verticalLine.backgroundColor = appDGrayColor
        bottomView.addSubview(verticalLine)
        verticalLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(bottomView.snp.centerX)
            make.width.equalTo(1)
            make.height.equalTo(35)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        
        // 底部View右边点赞
        praiseBottomButton = UIButton()
        
        if item.praiseFalse {
            praiseBottomButton.setTitle(" 已赞", for: .normal)
            praiseBottomButton.setTitleColor(UIColor.orange, for: .normal)
            praiseBottomButton.setImage(UIImage.init(named: "点赞-2"), for: .normal)
        }else {
            praiseBottomButton.setTitle(" 赞", for: .normal)
            praiseBottomButton.setTitleColor(UIColor.darkGray, for: .normal)
            praiseBottomButton.setImage(UIImage.init(named: "点赞"), for: .normal)
        }
        //        leaveMessageButton.backgroundColor = appDGrayColor
        bottomView.addSubview(praiseBottomButton)
        praiseBottomButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView.snp.centerY)
            make.width.equalTo((boundsWidth - 1)/2)
            make.height.equalTo(48)
            make.bottom.equalTo(0)
            make.centerX.equalTo(bottomView.snp.centerX).offset((boundsWidth/4))
        }
        praiseBottomButton.addTarget(self, action: #selector(praiseBottomButtonAction), for: .touchUpInside)
        
        
        // 用户头像
        let headImageView = UIButton()
        if item.image != nil {
//            headImageView.image = UIImage.init(data: item.image as! Data)
            headImageView.setImage(UIImage.init(data: item.image as! Data), for: .normal)
        }else {
//            headImageView.image = UIImage.init(named: "个人")
            headImageView.setImage(UIImage.init(named: "个人"), for: .normal)
        }        
        headImageView.layer.cornerRadius = 20
        headImageView.layer.masksToBounds = true
        headImageView.contentMode = .scaleAspectFill
        headImageView.addTarget(self, action: #selector(headImageViewAction), for: .touchUpInside)
        headView.addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.width.height.equalTo(40)
        }
        
        // 用户昵称
        let accountNameLabel = UILabel()
        accountNameLabel.text = item.accountName
        headView.addSubview(accountNameLabel)
        accountNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(10)
            make.top.equalTo(10)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        // 发布日期
        let releaseTime = UILabel()
        releaseTime.text = item.time
        releaseTime.textColor = UIColor.orange
        releaseTime.font = UIFont.systemFont(ofSize: 15)
        headView.addSubview(releaseTime)
        releaseTime.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(10)
            make.top.equalTo(accountNameLabel.snp.bottom)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        // 发布内容
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byCharWrapping
        contentLabel.text = item.content
        headView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        // 获取发布内容高度
        let contentLabelHeight = autoLabelHeight(with: item.content, labelWidth: boundsWidth, attributes: contentLabel.font)
        
        // collection的layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: (boundsWidth - 20 - 10)/3, height: (boundsWidth - 20 - 10)/3)
        layout.minimumLineSpacing = 5 // 最小行间距
        layout.minimumInteritemSpacing = 5 // 最小列间距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0) // 设置边距
        
        // 设置图片样式
        accountImages = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        accountImages.backgroundColor = UIColor.white
        accountImages.isScrollEnabled = false
        
        accountImages.register(MainPageCollectionCell.self, forCellWithReuseIdentifier: "MainPageCollectionCell")
        accountImages.delegate = self
        accountImages.dataSource = self
        headView.addSubview(accountImages)
        accountImages.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(boundsWidth - 20)
            make.height.equalTo(400)
            make.centerX.equalTo(headView.snp.centerX).offset(0)
        }
        
        // 图片的处理
        let itemCount = item.mainPagePhotos.count
        
        if itemCount == 0 { // 如果没有图片
            // collectionView的高就为0
            accountImages.snp.makeConstraints({ (make) in
                make.height.equalTo(0)
            })
            // 设置tableView的headView的高
            headView.frame = CGRect.init(x: 0, y: 0, width: boundsWidth, height: (60 + contentLabelHeight + 20))
            // 判断是否是点击整个cell还是cell上的“评论”button
            if commentOrDidSelect {
                // 如果是“评论”button，就要设置偏移量，直接移到评论
                tableView.contentOffset = CGPoint.init(x: 0, y: (60 + contentLabelHeight + 20))
            }else {
                tableView.contentOffset = CGPoint.init(x: 0, y: 0)
            }
            /************ 下面同理 根据照片数量来 ***************/
        }else if itemCount == 1 || itemCount == 2 || itemCount == 3 {
            accountImages.snp.makeConstraints({ (make) in
                make.height.equalTo((boundsWidth - 20 - 10)/3)
            })
            headView.frame = CGRect.init(x: 0, y: 0, width: boundsWidth, height: (60 + contentLabelHeight + (boundsWidth - 20 - 10)/3) + 20)
            if commentOrDidSelect {
                tableView.contentOffset = CGPoint.init(x: 0, y: (60 + contentLabelHeight + (boundsWidth - 20 - 10)/3) + 20)
            }else {
                tableView.contentOffset = CGPoint.init(x: 0, y: 0)
            }
        }else if itemCount == 4 || itemCount == 5 || itemCount == 6 {
            accountImages.snp.makeConstraints({ (make) in
                make.height.equalTo(((boundsWidth - 20 - 10)/3)*2)
            })
            headView.frame = CGRect.init(x: 0, y: 0, width: boundsWidth, height: (60 + contentLabelHeight + (boundsWidth - 20 - 10)/3*2) + 20)
            if commentOrDidSelect {
                tableView.contentOffset = CGPoint.init(x: 0, y: (60 + contentLabelHeight + (boundsWidth - 20 - 10)/3*2) + 20)
            }else {
                tableView.contentOffset = CGPoint.init(x: 0, y: 0)
            }
        }else if itemCount == 7 || itemCount == 8 || itemCount == 9 {
            accountImages.snp.makeConstraints({ (make) in
                make.height.equalTo(((boundsWidth - 20 - 10)/3)*3)
            })
            headView.frame = CGRect.init(x: 0, y: 0, width: boundsWidth, height: (60 + contentLabelHeight + (boundsWidth - 20 - 10)/3*3) + 20)
            if commentOrDidSelect {
                tableView.contentOffset = CGPoint.init(x: 0, y: (60 + contentLabelHeight + (boundsWidth - 20 - 10)/3*3) + 20)
            }else {
                tableView.contentOffset = CGPoint.init(x: 0, y: 0)
            }
        }
        
        accountImages.reloadData()
        
    }
    
    // 点击用户头像的点击事件
    func headImageViewAction() {
        let vc = UserDetailVC()
        vc.userAccount = item.accountID
        vc.userCurrentNickname = item.accountName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击评论按钮点击事件
    func leaveMessageButtonAction() {
        let vc = WriteLeaveMessageVC()
        vc.item = self.item
        self.present(vc, animated: true, completion: nil)
   
    }
    
    // 点击赞按钮点击事件
    func praiseBottomButtonAction() {
        
        let currentID = currentUserID()
        
        // 判断点赞
        if item.praiseFalse {
            praiseBottomButton.setTitle(" 赞", for: .normal)
            praiseBottomButton.setTitleColor(UIColor.darkGray, for: .normal)
            praiseBottomButton.setImage(UIImage.init(named: "点赞"), for: .normal)
            
            for i in 0..<item.praisePeople.count {
                if item.praisePeople[i].praiseName == currentID {// 找到当前登陆用户
                    try! self.realm.write {
                        self.realm.delete(item.praisePeople[i])// 从点赞用户里面删除
                    }
                    break // break，不然会数组越界
                }
            }
            
            try! realm.write {
                item.praiseNumber = item.praiseNumber - 1
                item.praiseFalse = false
                self.realm.add(item, update: true)
            }
        }else {
            praiseBottomButton.setTitle(" 已赞", for: .normal)
            praiseBottomButton.setTitleColor(UIColor.orange, for: .normal)
            praiseBottomButton.setImage(UIImage.init(named: "点赞-2"), for: .normal)
            
            let praisePeople = PraisePeople()
            praisePeople.praiseName = currentID // 将当前登陆用户传值给praisePeople
            try! self.realm.write { // 更新数据库
                item.praiseNumber = item.praiseNumber + 1
                item.praiseFalse = true
                item.praisePeople.append(praisePeople) // 把当前登陆用户储存到点赞的数据库中
                self.realm.add(item, update: true)
            }
            
            
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if item.praiseFalse {
            praiseBottomButton.setTitle(" 已赞", for: .normal)
            praiseBottomButton.setTitleColor(UIColor.orange, for: .normal)
            praiseBottomButton.setImage(UIImage.init(named: "点赞-2"), for: .normal)
        }else {
            praiseBottomButton.setTitle(" 赞", for: .normal)
            praiseBottomButton.setTitleColor(UIColor.darkGray, for: .normal)
            praiseBottomButton.setImage(UIImage.init(named: "点赞"), for: .normal)
        }
        
        tableView.reloadData()
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

extension MainPageCellDetails: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if chooseLeaveMessage {
            return item.leaveMessage.count
        }else {
            return item.praiseNumber
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if chooseLeaveMessage {
            let cell: LeaveMessageCell = tableView.dequeueReusableCell(withIdentifier: "LeaveMessageCell") as! LeaveMessageCell // cell复用
            
            cell.configerLeaveMessageCell(model: item.leaveMessage[indexPath.row])
            
            return cell
//            return UITableViewCell()
        }else {
            let cell: PraiseCell = tableView.dequeueReusableCell(withIdentifier: "praiseCell") as! PraiseCell // cell复用
            // 找出点赞人的账号
            let userInfor = item.praisePeople
            
            if userInfor.count > 0 {
                // 下载用户
                let userAccount = try! Realm().objects(User.self)
                
                for i in userAccount {
                    if userInfor[indexPath.row].praiseName == i.userName{
                        cell.configerMainPageCell(model: i.userInfo!)
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 底层视图
        let baseView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: boundsWidth, height: 30))
        baseView.backgroundColor = appDGrayColor
        
        // “评论”和“赞”的那一层视图
        let whiteView = UIView.init(frame: CGRect.init(x: 0, y: 10, width: boundsWidth, height: 40))
        whiteView.backgroundColor = UIColor.white
        baseView.addSubview(whiteView)
        
        // 评论按钮
        commentButton = UIButton()
        commentButton.setTitle("评论 \(item.leaveMessage.count)", for: .normal)
        
        if chooseLeaveMessage == true{
            commentButton.setTitleColor(UIColor.black, for: .normal)
            commentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }else {
            commentButton.setTitleColor(UIColor.darkGray, for: .normal)
            commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        }
        
        whiteView.addSubview(commentButton)
        commentButton.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(whiteView.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        commentButton.addTarget(self, action: #selector(commentButtonAction), for: .touchUpInside)
        
        // 点赞按钮
        praiseButton = UIButton()
        praiseButton.setTitle("赞 \(item.praiseNumber)", for: .normal)
        
        if chooseLeaveMessage == false {
            praiseButton.setTitleColor(UIColor.black, for: .normal)
            praiseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }else {
            praiseButton.setTitleColor(UIColor.darkGray, for: .normal)
            praiseButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        }
        
        whiteView.addSubview(praiseButton)
        praiseButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.equalTo(whiteView.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        praiseButton.addTarget(self, action: #selector(praiseButtonAction), for: .touchUpInside)
        
        // 底部横线动画
        lineLabel = UILabel()
        lineLabel.backgroundColor = appBlueColor
        lineLabel.layer.cornerRadius = 5
        lineLabel.layer.masksToBounds = true
        if chooseLeaveMessage {
            lineLabel.frame = CGRect.init(x: 20, y: 50, width: 50, height: 10)
        }else {
            self.lineLabel.frame = CGRect.init(x: boundsWidth - 70, y: 50, width: 50, height: 10)
        }
        
        baseView.addSubview(lineLabel)

        return baseView
    }
    
    // tableview头视图高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if chooseLeaveMessage {
            return UITableViewAutomaticDimension
        }else {
            return 60
        }
    }
    
    // 选中cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if chooseLeaveMessage {
            let userInfor = item.leaveMessage[indexPath.row].currentLeaveID
            
            let vc = UserDetailVC()
            
            vc.userAccount = userInfor
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            // 获取选中的账号
            let userInfor = item.praisePeople[indexPath.row].praiseName
            
            let vc = UserDetailVC()
            
            vc.userAccount = userInfor
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 点击评论的后
    func commentButtonAction() {
        
        // 点击评论切换
        chooseLeaveMessage = true
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.lineLabel.frame = CGRect.init(x: 20, y: 50, width: 50, height: 10)
        }) { (true) in
            self.tableView.reloadData()
        }
    }
    
    // 点击赞后
    func praiseButtonAction() {
        
        // 点击赞的按钮
        chooseLeaveMessage = false
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.lineLabel.frame = CGRect.init(x: boundsWidth - 70, y: 50, width: 50, height: 10)
        }) { (true) in
            self.tableView.reloadData()
        }
    }
}

extension MainPageCellDetails: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.mainPagePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = item.mainPagePhotos[indexPath.item]
        
        let cell: MainPageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageCollectionCell", for: indexPath) as! MainPageCollectionCell
        
        cell.imageBlock = {
            for i in self.item.mainPagePhotos {
                self.images.append(UIImage.init(data: i.image as! Data)!)
            }
            let lightboxImages = self.images.map {
                return LightboxImage.init(image: $0)
            }
            let lightbox = LightboxController.init(images: lightboxImages, startIndex: indexPath.item)
            lightbox.dismissalDelegate = self
            self.present(lightbox, animated: true, completion: nil)
        }
        
        cell.configModel(model: model)
        
        return cell
    }
    
}

extension MainPageCellDetails: LightboxControllerDismissalDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        self.images.removeAll()
    }
}
