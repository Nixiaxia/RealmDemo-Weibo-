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
    
    private var scrollView: UIScrollView! // 底层滚动视图
    
    private var headView: UIView! // 头部视图
    private var headImageButton: UIButton! // 头部头像
    private var headNameLB: UILabel! // 头部姓名
    private var headNumberLB: UILabel! // 头部电话
    private var waverView: UIView! // 波浪
    private var foucsDoctor: UIView! // 关注的医生
    private var foucsHospital: UIView! // 关注的医院
    
    private var setting: cellView! // 设置
    
    var imageBlock: (([UIImage])->())?
    
    private let headHeight = (UIScreen.main.bounds.height)*290/736 // 头部高度
    
    private var speed: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = appDGrayColor
        
        createScrollView()
        
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
            make.height.equalTo((UIScreen.main.bounds.height)*290/736)
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
            make.height.equalTo((headHeight)*30/290)
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
            make.height.equalTo((headHeight)*20/290)
        }
        
        // 波浪
        waverView = UIView()
        waverView.backgroundColor = UIColor.white
        headView.addSubview(waverView)
        waverView.snp.makeConstraints { (make) in
            make.top.equalTo(headNumberLB.snp.bottom)
            make.centerX.equalTo(headView)
            make.width.equalTo(boundsWidth)
            make.height.equalTo((headHeight)*30/290)
        }
        createWaver()
        
        // 关注的医生
        foucsDoctor = UIView()
        foucsDoctor.backgroundColor = UIColor.white
        headView.addSubview(foucsDoctor)
        foucsDoctor.snp.makeConstraints { (make) in
            make.top.equalTo(waverView.snp.bottom)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(boundsWidth/2)
        }
        // 关注医生的数量
        let foucsNumberLB_1 = UILabel()
        foucsNumberLB_1.text = "0"
        foucsNumberLB_1.font = UIFont.systemFont(ofSize: 20)
        foucsNumberLB_1.textAlignment = .center
        foucsDoctor.addSubview(foucsNumberLB_1)
        foucsNumberLB_1.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalTo(foucsDoctor)
            make.height.equalTo(foucsDoctor.snp.height).multipliedBy(0.5)
            make.width.equalTo(boundsWidth/2)
        }
        
        //“关注的医生”
        let foucsDoctorLB_1 = UILabel()
        foucsDoctorLB_1.text = "关注的医生"
        foucsDoctorLB_1.textAlignment = .center
        foucsDoctor.addSubview(foucsDoctorLB_1)
        foucsDoctorLB_1.snp.makeConstraints { (make) in
            make.top.equalTo(foucsNumberLB_1.snp.bottom)
            make.centerX.equalTo(foucsDoctor)
            //            make.bottom.equalTo(-20)
            make.width.equalTo(boundsWidth/2)
        }
        
        // 关注的医院
        foucsHospital = UIView()
        foucsHospital.backgroundColor = UIColor.white
        headView.addSubview(foucsHospital)
        foucsHospital.snp.makeConstraints { (make) in
            make.top.equalTo(waverView.snp.bottom)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(boundsWidth/2)
        }
        // 关注医院的数量
        let foucsNumberLB_2 = UILabel()
        foucsNumberLB_2.text = "0"
        foucsNumberLB_2.font = UIFont.systemFont(ofSize: 20)
        foucsNumberLB_2.textAlignment = .center
        foucsHospital.addSubview(foucsNumberLB_2)
        foucsNumberLB_2.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalTo(foucsHospital)
            make.height.equalTo(foucsHospital.snp.height).multipliedBy(0.5)
            make.width.equalTo(boundsWidth/2)
        }
        //“关注的医院”
        let foucsDoctorLB_2 = UILabel()
        foucsDoctorLB_2.text = "关注的医院"
        foucsDoctorLB_2.textAlignment = .center
        foucsHospital.addSubview(foucsDoctorLB_2)
        foucsDoctorLB_2.snp.makeConstraints { (make) in
            make.top.equalTo(foucsNumberLB_1.snp.bottom)
            make.centerX.equalTo(foucsHospital)
            //            make.bottom.equalTo(-20)
            make.width.equalTo(boundsWidth/2)
        }

        
        // 设置
//        setting = cellView()
//        setting.initWithFrame(image: "set", leftName: "设置", rightName: nil)
//        setting.isUserInteractionEnabled = true
//        scrollView.addSubview(setting)
//        setting.snp.makeConstraints { (make) in
//            make.top.equalTo(foucsHospital.snp.bottom).offset(12)
//            make.width.equalTo(scrollView)
//            make.height.equalTo(50)
//            make.left.equalTo(0)
//        }
        
        // 退出登录
        let logout = UIButton()
        logout.setTitle("退出", for: .normal)
        logout.backgroundColor = UIColor.red
        logout.setTitleColor(UIColor.white, for: .normal)
        logout.titleLabel?.textAlignment = .center
        scrollView.addSubview(logout)
        logout.snp.makeConstraints { (make) in
            make.top.equalTo(foucsHospital.snp.bottom).offset(12)
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
        
        let waveView_1 = WaveView.init(frame: CGRect.init(x: -5, y: 15, width: boundsWidth+10, height: 10+(headHeight)*30/290))//.init(frame: CGRectMake(-5, 15, boundsWidth+10, 10+(headHeight)*30/290))
        
        waverView.addSubview(waveView_1)
        
        waveView_1.startWave()
        
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
