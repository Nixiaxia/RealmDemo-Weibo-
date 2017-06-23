//
//  PersonalInforViewController.swift
//  OC -> Swift
//
//  Created by 逆夏夏 on 2017/2/14.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import RealmSwift
import ImagePicker
import Lightbox

class MinePageVC: UIViewController {
    
    let realm = try! Realm()
    var deleteAccount: Results<SaveAccount>?
    var user:Results<User>?
    
    var myReleaseArray = [MainPageModel]()
    
    private var scrollView: UIScrollView! // 底层滚动视图
    
    private var headView: UIView! // 头部视图
    private var headImageButton: UIButton! // 头部头像
    private var headNameLB: UILabel! // 头部姓名
    private var headNumberLB: UILabel! // 头部电话
    private var waverView: UIView! // 波浪
    
    private var myRelease: CustomUIButton! // 我的发布
    private var focus: CustomUIButton! // 关注
    private var fans: CustomUIButton! // 粉丝
    
    var imageBlock: (([UIImage])->())?
    
//    private let headHeight = (UIScreen.main.bounds.height)*290/736 // 头部高度
    
    private var speed: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = appDGrayColor
        
//        download()
        
        createScrollView()
  
    }
    
    // 生命周期view将要出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        download()

        // 获取当前用户ID
        let currentUserId = currentUserID()
        // 获取当前用户ID获取当前用户的信息
        let currentUserInfo = try! Realm().objects(User.self).filter("userName == '\(currentUserId)'")
        
        self.navigationController?.isNavigationBarHidden = true
        myRelease.number = myReleaseArray.count
        focus.number = currentUserInfo.first?.userInfo?.attentionPeople.count
        fans.number = currentUserInfo.first?.userInfo?.fansPeople.count
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // 创建底层滑动页面
    func createScrollView() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = appDGrayColor //appDGrayColor
        scrollView.contentSize = CGSize.init(width: boundsWidth, height: boundsHeight)//CGSizeMake(boundsWidth, boundsHeight)
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.alwaysBounceHorizontal = false
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom .equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        createHeadView()
    }
    
    func createHeadView() {
        
        // 获取当前用户ID
        let currentUserId = currentUserID()
        // 获取当前用户ID获取当前用户的信息
        let currentUserInfo = try! Realm().objects(User.self).filter("userName == '\(currentUserId)'")
   
        headView = UIView()
        headView.backgroundColor = UIColor.white
        scrollView.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView).offset(-20)
            make.left.equalTo(scrollView)
            make.height.equalTo(290)
            make.width.equalTo(self.view.bounds.width)
        }
        
        // 头部头像        
        headImageButton = UIButton()
        
        if currentUserInfo.first?.userInfo?.image == nil {
            headImageButton.setBackgroundImage(UIImage.init(named: "个人"), for: .normal)
        }else {
            headImageButton.setBackgroundImage(UIImage.init(data: (currentUserInfo.first?.userInfo?.image)! as Data), for: .normal)
        }
        headImageButton.contentMode = .scaleAspectFill
        headImageButton.layer.cornerRadius = 35
        headImageButton.layer.masksToBounds = true
        headImageButton.layer.borderWidth = 2
        headImageButton.layer.borderColor = appDGrayColor.cgColor
        headView.addSubview(headImageButton)
        headImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(55)
            make.centerX.equalTo(headView)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        headImageButton.addTarget(self, action: #selector(headImageButtonAction), for: .touchUpInside)
        
        self.imageBlock = {(images) in
            let userImage = images.first?.scaleImage(scaleSize: 0.1)
            self.headImageButton.setBackgroundImage(userImage, for: .normal)
            showHUD(text: "头像设置成功", to: self.view)
            let userImageData = UIImagePNGRepresentation(userImage!)

            try! self.realm.write {
                currentUserInfo.first?.userInfo?.image = userImageData as NSData?
            }
            
            // 获取当前用户昵称
            let currentNickname = currentUserNickname()
            // 获取当前用户头像
            let currentImage = currentUserImage()
            
            let mainPageModel = try! Realm().objects(MainPageModel.self)
            
            for i in mainPageModel {
                if i.accountName == currentNickname {
                    try! Realm().write {
                        i.image = currentImage
                    }
                }
            }
        }
        
        // 头部姓名
        headNameLB = UILabel()
        let userNickname = currentUserInfo.first?.userInfo?.userNickname
        if userNickname != nil {
            headNameLB.text = userNickname
        }else {
            headNameLB.text = ""
        }
        headNameLB.textAlignment = .center
        headView.addSubview(headNameLB)
        headNameLB.snp.makeConstraints { (make) in
            make.top.equalTo(headImageButton.snp.bottom).offset(5)
            make.centerX.equalTo(headView)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(30)
        }
        
        // 头部账号
        headNumberLB = UILabel()
        headNumberLB.font = UIFont.systemFont(ofSize: 14)
        headNumberLB.text = currentUserId
        headNumberLB.textAlignment = .center
        headView.addSubview(headNumberLB)
        headNumberLB.snp.makeConstraints { (make) in
            make.top.equalTo(headNameLB.snp.bottom)
            make.centerX.equalTo(headView)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(20)
        }
        
        // 波浪
        waverView = UIView()
        waverView.backgroundColor = UIColor.white
        headView.addSubview(waverView)
        waverView.snp.makeConstraints { (make) in
            make.top.equalTo(headNumberLB.snp.bottom)
            make.centerX.equalTo(headView)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(30)
        }
        createWaver()
        
        // 我的发布
        myRelease = CustomUIButton()
        myRelease.initWithProperty(titleString: "我的发布")
        myRelease.number = myReleaseArray.count
        headView.addSubview(myRelease)
        myRelease.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(boundsWidth/3)
            make.height.equalTo(55)
        }
        myRelease.addTarget(self, action: #selector(myReleaseAction), for: .touchUpInside)
        
        // 关注
        focus = CustomUIButton()
        focus.initWithProperty(titleString: "关注")
        focus.number = currentUserInfo.first?.userInfo?.attentionPeople.count
        headView.addSubview(focus)
        focus.snp.makeConstraints { (make) in
            make.left.equalTo(myRelease.snp.right)
            make.bottom.equalTo(0)
            make.width.equalTo(boundsWidth/3)
            make.height.equalTo(55)
        }
        focus.addTarget(self, action: #selector(focusAction), for: .touchUpInside)
        
        // 粉丝
        fans = CustomUIButton()
        fans.initWithProperty(titleString: "粉丝")
        fans.number = currentUserInfo.first?.userInfo?.fansPeople.count
        headView.addSubview(fans)
        fans.snp.makeConstraints { (make) in
            make.left.equalTo(focus.snp.right)
            make.bottom.equalTo(0)
            make.width.equalTo(boundsWidth/3)
            make.height.equalTo(55)
        }
        fans.addTarget(self, action: #selector(fansAction), for: .touchUpInside)
 
        // 退出登录
        let logout = UIButton()
        logout.setTitle("退出", for: .normal)
        logout.backgroundColor = UIColor.red
        logout.setTitleColor(UIColor.white, for: .normal)
        logout.titleLabel?.textAlignment = .center
        scrollView.addSubview(logout)
        logout.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.bottom).offset(12)
            make.width.equalTo(scrollView)
            make.height.equalTo(50)
            make.left.equalTo(0)
        }
        logout.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
   
    }
    
    func headImageButtonAction() {
        let imagePicker = ImagePickerController()
        imagePicker.imageLimit = 1
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func logoutAction() {
        
        deleteUser()
        
//        self.dismiss(animated: true, completion: nil)
        
        let vc = LoginVC()
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func deleteUser() {
        deleteAccount = realm.objects(SaveAccount.self)
        
        // 删除保存的用户账号
        try! realm.write {
            realm.delete(deleteAccount!)
        }
    }
    
    func createWaver() {
        
        let waveView_1 = WaveView.init(frame: CGRect.init(x: -5, y: 15, width: boundsWidth+10, height: 10+30))//.init(frame: CGRectMake(-5, 15, boundsWidth+10, 10+(headHeight)*30/290))
        
        waverView.addSubview(waveView_1)
        
        waveView_1.startWave()
        
    }
    
    // 点击“我的发布”方法
    func myReleaseAction() {
        let vc = MyReleaseVC()
        vc.hidesBottomBarWhenPushed = true
        vc.consumeItems = myReleaseArray.reversed()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // 点击“关注”方法
    func focusAction() {
        // 获取当前用户ID
        let currentUserId = currentUserID()
        // 获取当前用户ID获取当前用户的信息
        let currentUserInfo = try! Realm().objects(User.self).filter("userName == '\(currentUserId)'")
        let vc = AttentionPeopleVC()
        var itemArray = [AttentionPeople]()
        for i in (currentUserInfo.first?.userInfo?.attentionPeople)! {
            itemArray.append(i)
        }
        vc.itemFoucs = itemArray
        vc.isFoucs = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击“粉丝”方法
    func fansAction() {
        // 获取当前用户ID
        let currentUserId = currentUserID()
        // 获取当前用户ID获取当前用户的信息
        let currentUserInfo = try! Realm().objects(User.self).filter("userName == '\(currentUserId)'")
        let vc = AttentionPeopleVC()
        var itemArray = [FansPeople]()
        for i in (currentUserInfo.first?.userInfo?.fansPeople)! {
            itemArray.append(i)
        }
        vc.itemFans = itemArray
        vc.isFoucs = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 下载方法
    func download() {
        
        myReleaseArray.removeAll()
        
        // 获取当前登陆用户昵称
        let currentNickname = currentUserNickname()
        
        let mainPageModel = realm.objects(MainPageModel.self)
        
        for i in mainPageModel{
            if i.accountName == currentNickname {
                myReleaseArray.append(i)
            }
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
extension MinePageVC: ImagePickerDelegate {
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) { // cancel按钮响应时间
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) { // 相框按钮响应事件
        guard images.count > 0 else {
            return
        }
        let lightboxImages = images.map {
            return LightboxImage.init(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    // done响应事件
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imageBlock!(images) // 将选择的照片闭包传出去
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
