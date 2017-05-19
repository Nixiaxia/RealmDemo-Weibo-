//
//  WriteLeaveMessageVC.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/5/6.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import RealmSwift

class WriteLeaveMessageVC: UIViewController {
    
    var item = MainPageModel()
    
    let realm = try! Realm()
    
    var navigationView: UIView! // 自定义导航栏
    var issueButton: UIButton! // 发布按钮
    var writeTextView: UITextView! // 编辑文本框
    var noteTextLabel: UILabel! // 文本框提示文字

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = appDGrayColor
        
        createNavButton()
        
        createUI()
        
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
        noteTextLabel.text = "赶快评论下Ta的新鲜事吧..."
        noteTextLabel.isHidden = false
        noteTextLabel.textColor = UIColor.init(red: 0.3059, green: 0.3137, blue: 0.3137, alpha: 0.5)
        noteTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.writeTextView.addSubview(noteTextLabel)
        noteTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(8)
            make.width.equalTo(250)
            make.height.equalTo(20)
        }
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
    navTitle.text = "评论Ta"
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
    issueButton.setTitle("评论", for: .normal)
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
    
    // 点击取消按钮
    func cancelButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    // 点击评论按钮
    func issueButtonAction() {
        
        // 下载当前登陆用户昵称
        let currentID = currentUserNickname()
        // 下载当前登陆用户账号
        let currentAccountID = currentUserID()
        // 获取当前时间
        let currentIssueTime = currentTime()
        // 获取当前登陆用户头像
        let currentImage = currentUserImage()
        // 留言ID
        let timeInterval = NSDate().timeIntervalSince1970 * 10000
        
        let leaveMessageInfo = UserMessage()
        leaveMessageInfo.leaveID = Int(timeInterval)
        leaveMessageInfo.currentLeaveID = currentAccountID
        leaveMessageInfo.currentLeaveHeadImage = currentImage
        leaveMessageInfo.leaveMessageTime = currentIssueTime
        leaveMessageInfo.accountNickname = currentID
        leaveMessageInfo.accountLeaveMessage = writeTextView.text
        
        try! realm.write {
            item.leaveMessage.append(leaveMessageInfo)
        }
        
        self.dismiss(animated: true, completion: nil)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        writeTextView.resignFirstResponder()
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

extension WriteLeaveMessageVC: UITextViewDelegate {
    
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
