//
//  WritePage.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/2/14.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import RealmSwift
import ImagePicker
import Lightbox

class WritePageVC: UIViewController {
    
    let realm = try! Realm()
   
    var navigationView: UIView! // 自定义导航栏
    var issueButton: UIButton! // 发布按钮
    var writeTextView: UITextView! // 编辑文本框
    var noteTextLabel: UILabel! // 文本框提示文字
    
    var addImageButton: UIButton! // 添加照片button
    
    var mainPageModel: MainPageModel!
    
    var imageBlock: (([UIImage]) -> ())? // 选择照片后闭包传值
    
    var imagesArray = [UIImage]()
    var imagesM = NSMutableArray()
    
    var publishPhotosView: PYPhotosView! // 选择上传图片
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = appDGrayColor
        
        createNavButton()
        
        createUI()
        
    }
    
    func createNavButton() {// 集合导航栏视图
        
        // 自定义导航栏
        navigationView = UIView()
        navigationView.backgroundColor = UIColor.white
        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(64)
        }
        
        // 中间“发动态”的title
        let navTitle = UILabel()
        navTitle.text = "发动态"
        navTitle.textAlignment = .center
        navTitle.font = UIFont.boldSystemFont(ofSize: 20)
        navTitle.textColor = UIColor.black
        self.navigationView.addSubview(navTitle)
        navTitle.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.centerX.equalTo(self.navigationView.snp.centerX).offset(0)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        // 左边“取消”的button
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.navigationView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(25)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        // 右边“发布”的button
        issueButton = UIButton()
        issueButton.setTitle("发布", for: .normal)
        issueButton.setTitleColor(UIColor.white, for: .normal)
        issueButton.layer.cornerRadius = 5
        issueButton.layer.masksToBounds = true
        self.navigationView.addSubview(issueButton)
        issueButton.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.right.equalTo(-10)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        issueButton.addTarget(self, action: #selector(issueButtonAction), for: .touchUpInside)
        
    }
    
    func issueButtonAction() { // 发布按钮的点击事件
        
        // 下载当前登陆用户昵称
        let currentID = currentUserNickname()
        // 获取当前时间
        let currentIssueTime = currentTime()
        // 获取当前登陆用户头像
        let currentImage = currentUserImage()
        
        let timeInterval = NSDate().timeIntervalSince1970 * 1000
        
        mainPageModel = MainPageModel()
        mainPageModel.ID = Int(timeInterval)
        mainPageModel.accountName = currentID
        mainPageModel.time = currentIssueTime
        mainPageModel.accountID = currentUserID()
        mainPageModel.content = writeTextView.text
        mainPageModel.praiseNumber = 0
        mainPageModel.praiseFalse = false
        mainPageModel.image = currentImage

        if imagesM.count == 0 {
            
        }else if imagesM.count >= 1 && imagesM.count <= 9 {
            print(imagesM.count)
            for index in 0..<imagesM.count {
                let i = imagesM[index]
                let image = (i as! UIImage).scaleImage(scaleSize: 0.02)
                let imageData = UIImagePNGRepresentation(image)
                let mainPageImage = MainPagePhotos()
                mainPageImage.image = imageData as NSData?
                mainPageModel.mainPagePhotos.append(mainPageImage)
            }
        }else if imagesM.count > 9 {
            for index in 0..<9 {
                let i = imagesM[index]
                let image = (i as! UIImage).scaleImage(scaleSize: 0.02)
                let imageData = UIImagePNGRepresentation(image)
                let mainPageImage = MainPagePhotos()
                mainPageImage.image = imageData as NSData?
                mainPageModel.mainPagePhotos.append(mainPageImage)
            }
        }
        
        try! realm.write {
            realm.add(mainPageModel)
        }
        
        // 写入后清除内容
        writeTextView.text = ""
        imagesM.removeAllObjects()
        noteTextLabel.isHidden = false
        publishPhotosView.reloadData(with: imagesM)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectIndex"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
    }
    
    func cancelButtonAction() { // “取消”点击事件，取消后回到第一个VC

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectIndex"), object: nil)
        
        writeTextView.text = ""
        noteTextLabel.isHidden = false
        imagesM.removeAllObjects()
        publishPhotosView.reloadData(with: imagesM)
        
    }
    
    func createUI() {
        // 编辑文本框
        writeTextView = UITextView()
        writeTextView.backgroundColor = UIColor.white
        writeTextView.font = UIFont.systemFont(ofSize: 18)
        writeTextView.delegate = self
        self.view.addSubview(writeTextView)
        writeTextView.snp.makeConstraints { (make) in
            make.top.equalTo(65)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(200)
        }
        
        // 编辑文本框里面的提示文字，textView不像textfiled有.placeholder属性，所以得自己写
        noteTextLabel = UILabel()
        noteTextLabel.text = "赶快分享你的新鲜事吧..."
        noteTextLabel.isHidden = false
        noteTextLabel.textColor = UIColor.init(red: 0.3059, green: 0.3137, blue: 0.3137, alpha: 0.5)
        noteTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.writeTextView.addSubview(noteTextLabel)
        noteTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(8)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        self.imageBlock = { (images) in
            
            if images.count > 9 {
                for i in 0..<9 {
                    self.imagesM.add(images[i])
                }
            }else {
                for i in 0..<images.count {
                    self.imagesM.add(images[i])
                }
            }
    
            self.publishPhotosView.reloadData(with: self.imagesM)
        }
        
        // 添加图片
        publishPhotosView = PYPhotosView()
        publishPhotosView.images = imagesM
        publishPhotosView.delegate = self
        self.view.addSubview(publishPhotosView)
        publishPhotosView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(writeTextView.snp.bottom).offset(10)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(300)
        }
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        writeTextView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        issueButton.isEnabled = false
        issueButton.backgroundColor = UIColor.init(red: 0.3059, green: 0.3137, blue: 0.3137, alpha: 0.5)
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

extension WritePageVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" { // 如果输入框为空
            noteTextLabel.isHidden = false
            issueButton.isEnabled = false
            issueButton.backgroundColor = UIColor.init(red: 0.3059, green: 0.3137, blue: 0.3137, alpha: 0.5)
        }else { // 如果不为“”，判断是否是纯空格或者换行
            
            var writeString = ""
            
            writeString = writeTextView.text!
            
            for uni in writeString.unicodeScalars {

                if uni.value != 32 && uni.value != 10{
                    
                    noteTextLabel.isHidden = true
                    issueButton.isEnabled = true
                    issueButton.backgroundColor = appBlueColor
                }else {
                    if textView.text != "" {
                        
                        noteTextLabel.isHidden = true
                        issueButton.isEnabled = true
                        issueButton.backgroundColor = appBlueColor
                    }else {
                        noteTextLabel.isHidden = true
                        issueButton.isEnabled = false
                        issueButton.backgroundColor = UIColor.init(red: 0.3059, green: 0.3137, blue: 0.3137, alpha: 0.5)
                    }
                }
            }
        }
    }
}

extension WritePageVC: ImagePickerDelegate {
    
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

extension WritePageVC: PYPhotosViewDelegate {
    func photosView(_ photosView: PYPhotosView!, didAddImageClickedWithImages images: NSMutableArray!) { // PYPhotosView 加号按钮 跳转到ImagePicker这个框架
        
        let imagePicker = ImagePickerController()
        imagePicker.imageLimit = 9
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}
