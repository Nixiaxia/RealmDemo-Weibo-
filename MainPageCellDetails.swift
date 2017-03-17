//
//  MainPageCellDetails.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/3/14.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import Lightbox

class MainPageCellDetails: UIViewController {
    
    var item = MainPageModel() // 接收上个页面的值
    
    var offset = Int() // 偏移量
    
    var commentOrDidSelect = false
    
    var tableView: UITableView! // 评论的tableView
    
    var accountImages: UICollectionView! // 图片collectionView
    
    var images = [UIImage]() // 保存取出来的照片
    
    var commentButton: UIButton! // 评论按钮
    var praiseButton: UIButton! // 赞按钮
    
    var lineLabel: UILabel! // 底部横线动画
    
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
        tableView.backgroundColor = appDGrayColor
        tableView.frame = self.view.bounds
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        // tableView上的headView
        let headView = UIView()
        headView.backgroundColor = UIColor.white
        headView.frame = CGRect.init(x: 0, y: 0, width: boundsWidth, height: 200)
        tableView.tableHeaderView = headView
        
        // 用户头像
        let headImageView = UIImageView()
        if item.image != nil {
            headImageView.image = UIImage.init(data: item.image as! Data)
        }else {
            headImageView.image = UIImage.init(named: "个人")
        }        
        headImageView.layer.cornerRadius = 20
        headImageView.layer.masksToBounds = true
        headImageView.contentMode = .scaleAspectFill
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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 底层视图
        let baseView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: boundsWidth, height: 30))
        baseView.backgroundColor = appDGrayColor
        
        // 
        let whiteView = UIView.init(frame: CGRect.init(x: 0, y: 10, width: boundsWidth, height: 40))
        whiteView.backgroundColor = UIColor.white
        baseView.addSubview(whiteView)
        
        // 评论按钮
        commentButton = UIButton()
        commentButton.setTitle("评论 \(item.leaveMessage.count)", for: .normal)
        commentButton.setTitleColor(UIColor.black, for: .normal)
        commentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
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
        praiseButton.setTitleColor(UIColor.darkGray, for: .normal)
        praiseButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
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
        lineLabel.frame = CGRect.init(x: 20, y: 50, width: 50, height: 10)
        baseView.addSubview(lineLabel)

        return baseView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // 点击评论的后
    func commentButtonAction() {
        praiseButton.setTitleColor(UIColor.darkGray, for: .normal)
        praiseButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        commentButton.setTitleColor(UIColor.black, for: .normal)
        commentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        UIView.animate(withDuration: 0.3) {
            self.lineLabel.frame = CGRect.init(x: 20, y: 50, width: 50, height: 10)
        }
    }
    
    // 点击赞后
    func praiseButtonAction() {
        commentButton.setTitleColor(UIColor.darkGray, for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        praiseButton.setTitleColor(UIColor.black, for: .normal)
        praiseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        UIView.animate(withDuration: 0.3) {
            self.lineLabel.frame = CGRect.init(x: boundsWidth - 70, y: 50, width: 50, height: 10)
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
