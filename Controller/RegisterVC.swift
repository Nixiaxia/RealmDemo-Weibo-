//
//  registerVC.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/2/4.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import RealmSwift

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    var resultsUserName: Results<User>?
  
    var userName: UILabel! // “用户名”
    var userNameAlert: UILabel! // 用户名违规输入警告
    var userNameView: UIView!
    var userNameTextField: UITextField!
    
    var password: UILabel! // “用户密码”
    var passwordAlert: UILabel! // 密码违规输入警告
    var passwordView: UIView!
    var passwordTextField: UITextField!
    
    var userNickname: UILabel! // “用户昵称”
    var nicknameAlert: UILabel! // 昵称违规输入警告
    var nicknameView: UIView!
    var nicknameTextField: UITextField!
    
    var registerButton: UIButton! // “立即注册”按钮
    
    typealias backUser = (String, String) -> ()
    var blo: backUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = appDGrayColor
        
        createBackButton() // 自定义返回按钮
        
        createUI()
        
    }
    
    func createUI() {
        
        let titleLabel = UILabel()
        titleLabel.text = "用户注册"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = appBlueColor
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        // “用户账号”
        userName = UILabel()
        userName.text = "用户账号"
        userName.font = UIFont.boldSystemFont(ofSize: 15)
        userName.textColor = UIColor.darkGray
        self.view.addSubview(userName)
        userName.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.left.equalTo(10)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        // 账号违规输入警告
        userNameAlert = UILabel()
        userNameAlert.isHidden = true
        
        userNameAlert.font = UIFont.boldSystemFont(ofSize: 15)
        userNameAlert.textColor = UIColor.red
        self.view.addSubview(userNameAlert)
        userNameAlert.snp.makeConstraints { (make) in
            make.left.equalTo(userName.snp.right)
            make.top.equalTo(80)
            make.right.equalTo(-10)
            make.height.equalTo(30)
        }
        // 账号视图
        userNameView = UIView()
        userNameView.backgroundColor = UIColor.white
        self.view.addSubview(userNameView)
        userNameView.snp.makeConstraints { (make) in
            make.top.equalTo(userName.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        // 账号textfield
        userNameTextField = UITextField()
        userNameTextField.placeholder = "6～10位大小写英文、数字"
        userNameTextField.backgroundColor = UIColor.white
        userNameTextField.delegate = self
        userNameTextField.tag = 100
        userNameTextField.autocorrectionType = .no
        userNameTextField.autocapitalizationType = .none
        userNameTextField.returnKeyType = .next
        userNameTextField.keyboardType = .asciiCapable
        userNameTextField.clearButtonMode = .whileEditing
        userNameView.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(userName.snp.bottom)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(50)
        }
        
        // “密码”
        password = UILabel()
        password.text = "设置密码"
        password.font = UIFont.boldSystemFont(ofSize: 15)
        password.textColor = UIColor.darkGray
        self.view.addSubview(password)
        password.snp.makeConstraints { (make) in
            make.top.equalTo(userNameView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        // 密码违规输入警告
        passwordAlert = UILabel()
        passwordAlert.isHidden = true
        
        passwordAlert.font = UIFont.boldSystemFont(ofSize: 15)
        passwordAlert.textColor = UIColor.red
        self.view.addSubview(passwordAlert)
        passwordAlert.snp.makeConstraints { (make) in
            make.left.equalTo(password.snp.right)
            make.top.equalTo(userNameView.snp.bottom).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(30)
        }
        // 密码视图
        passwordView = UIView()
        passwordView.backgroundColor = UIColor.white
        self.view.addSubview(passwordView)
        passwordView.snp.makeConstraints { (make) in
            make.top.equalTo(password.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        // 密码textfield
        passwordTextField = UITextField()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "6～16位数字或字母，区分大小写"
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.delegate = self
        passwordTextField.tag = 101
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.returnKeyType = .next
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.clearButtonMode = .whileEditing
        passwordView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(password.snp.bottom)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(50)
        }
        
        // “昵称”
        userNickname = UILabel()
        userNickname.text = "昵称"
        userNickname.font = UIFont.boldSystemFont(ofSize: 15)
        userNickname.textColor = UIColor.darkGray
        self.view.addSubview(userNickname)
        userNickname.snp.makeConstraints { (make) in
            make.top.equalTo(passwordView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        // 昵称违规输入警告
        nicknameAlert = UILabel()
        nicknameAlert.isHidden = true
        
        nicknameAlert.font = UIFont.boldSystemFont(ofSize: 15)
        nicknameAlert.textColor = UIColor.red
        self.view.addSubview(nicknameAlert)
        nicknameAlert.snp.makeConstraints { (make) in
            make.left.equalTo(password.snp.right)
            make.top.equalTo(passwordView.snp.bottom).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(30)
        }
        // 昵称视图
        nicknameView = UIView()
        nicknameView.backgroundColor = UIColor.white
        self.view.addSubview(nicknameView)
        nicknameView.snp.makeConstraints { (make) in
            make.top.equalTo(userNickname.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        // 昵称textfield
        nicknameTextField = UITextField()
        nicknameTextField.placeholder = "4-24位字符：支持中文、英文、数字"
        nicknameTextField.backgroundColor = UIColor.white
        nicknameTextField.delegate = self
        nicknameTextField.tag = 102
        nicknameTextField.autocorrectionType = .no
        nicknameTextField.autocapitalizationType = .none
        nicknameTextField.returnKeyType = .done
        nicknameTextField.clearButtonMode = .whileEditing
        nicknameView.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(nicknameView.snp.centerY)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(50)
        }
        
        registerButton = UIButton()
        registerButton.setTitle("立即注册", for: .normal)
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.layer.cornerRadius = 5
        registerButton.layer.masksToBounds = true
        registerButton.backgroundColor = appBlueColor
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(nicknameView.snp.bottom).offset(20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(50)
        }
        registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
      
    }
    
    // “立即注册”按钮事件
    func registerButtonAction() {
        
//        func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//            //限制只能输入数字，不能输入特殊字符
//            let length = string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
//            for loopIndex in 0..<length {
//                let char = (string as NSString).characterAtIndex(loopIndex)
//                if char < 48 { return false }
//                if char > 57 { return false }
//            }
//            //限制长度
//            let proposeLength = (textField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! - range.length + string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
//            if proposeLength > 11 { return false }
//            return true  
//        }
        
        /****************** 用户账号检测 *******************/
        
        let userNameLength = userNameTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        
        if userNameLength! >= 6 && userNameLength! <= 10 { // 检测字符串长度

            for loopIndex in 0..<userNameLength! {
                let char = (userNameTextField.text! as NSString).character(at: loopIndex)
                if (char >= 48 && char <= 57) || (char >= 65 && char <= 90) || (char >= 97 && char <= 122) {
                    userNameAlert.isHidden = true
                }else {
                    userNameAlert.isHidden = false
                    userNameAlert.text = "账号为6～10位大小写英文、数字"
                    break
                }
            }
        }else {
            userNameAlert.isHidden = false
            userNameAlert.text = "账号为6～10位大小写英文、数字"
        }
        
        /****************** 用户密码检测 *******************/
        
        let passwordLength = passwordTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        if passwordLength! >= 6 && passwordLength! <= 16 { // 检测字符串长度
            
            for loopIndex in 0..<passwordLength! {
                let char = (passwordTextField.text! as NSString).character(at: loopIndex)
                if (char >= 48 && char <= 57) || (char >= 65 && char <= 90) || (char >= 97 && char <= 122) {
                    passwordAlert.isHidden = true
                }else {
                    passwordAlert.isHidden = false
                    passwordAlert.text = "密码为6～16位数字或字母，区分大小写"
                    break
                }
            }
        }else {
            passwordAlert.isHidden = false
            passwordAlert.text = "密码为6～16位数字或字母，区分大小写"
        }
        
        /****************** 用户昵称检测 *******************/
        
//        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
//        let matcher = MyRegex(mailPattern)
//        let maybeMailAddress = "admin@hangge.com"
//        if matcher.match(maybeMailAddress) {
//            print("邮箱地址格式正确")
//        }else{
//            print("邮箱地址格式有误")
//        }
        
        let nicknameLength = nicknameTextField.text?.lengthOfBytes(using: String.Encoding.utf8)
        // 验证长度
        if nicknameLength! >= 4 && nicknameLength! <= 24 {
            
            var nicknameString = ""
            
            nicknameString = nicknameTextField.text!
            
            for uni in nicknameString.unicodeScalars {
                if !((uni.value >= 65 && uni.value <= 90) || (uni.value >= 97 && uni.value <= 122) || (uni.value >= 48 && uni.value <= 57) || (uni.value >= 0x4e00 && uni.value <= 0x9fff)) {
                    nicknameAlert.isHidden = false
                    nicknameAlert.text = "昵称为4-24位字符：支持中文、英文、数字"
                    break
                }else {
                    nicknameAlert.isHidden = true
                }
            }
        }else {
            nicknameAlert.isHidden = false
            nicknameAlert.text = "昵称为4-24位字符：支持中文、英文、数字"
        }
        
        if userNameAlert.isHidden && passwordAlert.isHidden && nicknameAlert.isHidden{
            
            resultsUserName = realm.objects(User.self)
            
            if (self.resultsUserName?.count)! > 0 {
                
                var allowCreateUser = true
               
                for i in 0..<(self.resultsUserName?.count)! {
                    
                    if resultsUserName?[i].userName == userNameTextField.text! {
                        userNameAlert.isHidden = false
                        userNameAlert.text = "用户已存在!"
                        allowCreateUser = false
                        break
                    }
                    if resultsUserName?[i].userInfo?.userNickname == nicknameTextField.text!{
                        nicknameAlert.isHidden = false
                        nicknameAlert.text = "昵称已存在！"
                        allowCreateUser = false
                        break
                    }
                }
                
                if allowCreateUser {

                    createUser()
                    self.blo?(userNameTextField.text!, passwordTextField.text!)
                    self.dismiss(animated: true, completion: nil)
                }
            
            }else {

                createUser()
                self.blo?(userNameTextField.text!, passwordTextField.text!)
                self.dismiss(animated: true, completion: nil)
            }
            
            
        
//            let nickName = UserInfo()
//            nickName.userNickname = nicknameTextField.text!
//            
//            let user = User()
//            user.userName = userNameTextField.text!
//            user.passWord = passwordTextField.text!
//            user.userInfo = nickName
//            
//            try! realm.write {
//                realm.add(user)
//            }
//            
//            self.dismiss(animated: true, completion: nil)
        }
       
    }
    
    func createUser() {
        let nickName = UserInfo()
        nickName.userNickname = nicknameTextField.text!
        
        let user = User()
        user.userName = userNameTextField.text!
        user.passWord = passwordTextField.text!
        user.userInfo = nickName
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    // 自定义返回按钮
    func createBackButton() {
        let backButton = UIButton()
        backButton.setImage(UIImage.init(named: "返回"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    
    // textfield的reutrn响应
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        switch tag {
        case 100:
//            self.userNameTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        case 101:
//            self.passwordTextField.resignFirstResponder()
            self.nicknameTextField.becomeFirstResponder()
        case 102:
            self.nicknameTextField.resignFirstResponder()
        default:
            print(textField.text!)
        }
        return true
    }
    
    // 返回按钮事件
    func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 视图将要消失隐藏键盘
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nicknameTextField.resignFirstResponder()
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
