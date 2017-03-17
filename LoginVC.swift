//
//  LoginVC.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/2/4.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class LoginVC: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    var resultsUserName: Results<User>?
    
    var txtUser: UITextField! // 用户名输入框
    var userNameAlert: UILabel! // 用户名警告
    var txtPwd: UITextField! // 密码输入款
    var pwdAlert: UILabel! // 密码警告
    var formView: UIView! // 登陆框视图
    var horizontalLine: UIView! // 分隔线
    var confirmButton: UIButton! // 登录按钮
    var registerButton: UIButton! // 注册按钮
    var titleLabel: UILabel! // 标题标签
    
    var topConstraint: Constraint? //登录框距顶部距离约束
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //视图背景色
        self.view.backgroundColor = UIColor(red: 1/255, green: 170/255, blue: 235/255, alpha: 1)
        
        // 
//        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)
        
        createUI()
        
        }
    
    func createUI() {
        
        //登录框高度
        let formViewHeight = 90
        //登录框背景
        self.formView = UIView()
        self.formView.layer.borderWidth = 0.5
        self.formView.layer.borderColor = UIColor.lightGray.cgColor
        self.formView.backgroundColor = UIColor.white
        self.formView.layer.cornerRadius = 5
        self.view.addSubview(self.formView)
        //最常规的设置模式
        self.formView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            //存储top属性
            self.topConstraint = make.centerY.equalTo(self.view).offset(-80).constraint
            make.height.equalTo(formViewHeight)
        }
        
        //分隔线
        self.horizontalLine =  UIView()
        self.horizontalLine.backgroundColor = UIColor.lightGray
        self.formView.addSubview(self.horizontalLine)
        self.horizontalLine.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(0.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(self.formView)
        }
        
        //用户图
        let imgLock1 =  UIImageView(frame:CGRect.init(x: 11, y: 11, width: 22, height: 22))
        imgLock1.image = UIImage(named:"iconfont-user")
        
        //密码图
        let imgLock2 =  UIImageView(frame:CGRect.init(x: 11, y: 11, width: 22, height: 22))
        imgLock2.image = UIImage(named:"iconfont-password")
        
        //用户名输入框
        self.txtUser = UITextField()
        self.txtUser.delegate = self
        self.txtUser.placeholder = "用户名"
        self.txtUser.tag = 100
        self.txtUser.clearButtonMode = .whileEditing
        self.txtUser.autocorrectionType = .no // 取消自动联想
        self.txtUser.autocapitalizationType = .none // 取消自动大小写
        self.txtUser.keyboardType = .asciiCapable // 只有英文数字的键盘
        self.txtUser.leftView = UIView(frame:CGRect.init(x: 0, y: 0, width: 44, height: 44))
        self.txtUser.leftViewMode = .always
        self.txtUser.returnKeyType = .next
      
        //用户名输入框左侧图标
        self.txtUser.leftView!.addSubview(imgLock1)
        self.formView.addSubview(self.txtUser)
        
        //布局
        self.txtUser.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.centerY.equalTo(formView.snp.centerY).offset(-formViewHeight/4)
        }
        
        // 用户名警告
        userNameAlert = UILabel()
        userNameAlert.isHidden = true
        userNameAlert.font = UIFont.systemFont(ofSize: 15)
        userNameAlert.textColor = UIColor.red
        self.txtUser.addSubview(userNameAlert)
        userNameAlert.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.top.bottom.equalTo(0)
            make.centerY.equalTo(txtUser.snp.centerY)
        }
        
        // 密码输入框
        self.txtPwd = UITextField()
        self.txtPwd.delegate = self
        self.txtPwd.placeholder = "密码"
        self.txtPwd.tag = 101
        self.txtPwd.clearButtonMode = .whileEditing
        self.txtPwd.isSecureTextEntry = true
        self.txtPwd.autocorrectionType = .no
        self.txtPwd.autocapitalizationType = .none
        self.txtPwd.keyboardType = .asciiCapable
        self.txtPwd.leftView = UIView(frame:CGRect.init(x: 0, y: 0, width: 44, height: 44))
        self.txtPwd.leftViewMode = .always
        self.txtPwd.returnKeyType = .next
        
        // 密码输入框左侧图标
        self.txtPwd.leftView!.addSubview(imgLock2)
        self.formView.addSubview(self.txtPwd)
        
        // 布局
        self.txtPwd.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.centerY.equalTo(formView.snp.centerY).offset(formViewHeight/4)
        }
        
        // 密码警告
        pwdAlert = UILabel()
        pwdAlert.font = UIFont.systemFont(ofSize: 15)
        pwdAlert.textColor = UIColor.red
        self.txtPwd.addSubview(pwdAlert)
        pwdAlert.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.top.bottom.equalTo(0)
            make.centerY.equalTo(txtPwd.snp.centerY)
        }
        
        // 登录按钮
        self.confirmButton = UIButton()
        self.confirmButton.setTitle("登录", for: UIControlState.normal)
        self.confirmButton.layer.cornerRadius = 5
        self.confirmButton.setTitleColor(UIColor.white, for: .normal)
        self.confirmButton.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        self.confirmButton.addTarget(self, action: #selector(loginConfrim),
                                     for: .touchUpInside)
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.top.equalTo(self.formView.snp.bottom).offset(20)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        
        // 注册按钮
        self.registerButton = UIButton()
        self.registerButton.setTitle("还没账号？赶紧注册一个吧！", for: UIControlState.normal)
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.setTitleColor(UIColor(colorLiteralRed: 0.2784, green: 0.6627, blue: 0.8980, alpha: 1), for: .normal)
        self.registerButton.backgroundColor = appDGrayColor
        self.registerButton.addTarget(self, action: #selector(registerButtonAction),
                                     for: .touchUpInside)
        self.view.addSubview(self.registerButton)
        self.registerButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.top.equalTo(confirmButton.snp.bottom).offset(10)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        
        //标题label
        self.titleLabel = UILabel()
        self.titleLabel.text = "DayOne.com"
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.font = UIFont.systemFont(ofSize: 36)
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.formView.snp.top).offset(-20)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(44)
        }

    }
    
    // 注册按钮
    func registerButtonAction() {
        let vc = RegisterVC()
        
        txtUser.text = ""
        txtPwd.text = ""
        userNameAlert.isHidden = true
        pwdAlert.isHidden = true
        
        vc.blo = {(userString, passwordString) -> Void in // 注册完成返回登录
            
            self.txtUser.text = userString
            self.txtPwd.text = passwordString
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // 输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        
        userNameAlert.isHidden = true
        pwdAlert.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: -125)
            self.view.layoutIfNeeded()
        })
    }
    
    // 输入框返回时操作
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        let tag = textField.tag
        switch tag {
        case 100:
            print(123)
            self.txtPwd.becomeFirstResponder()            
        case 101:
            loginConfrim()
        default:
            print(textField.text!)
        }
        return true
    }
    
    // 登录按钮点击
    func loginConfrim(){
        //收起键盘
        self.view.endEditing(true)
        //视图约束恢复初始设置
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.topConstraint?.update(offset: -80)
            self.view.layoutIfNeeded()
        })
        
        resultsUserName = realm.objects(User.self)
        
        var allowLogin = false // 判断是否允许登录
        
        if txtUser.text == "" { // 判断用户输入是否为空
            userNameAlert.isHidden = false
            userNameAlert.text = "用户名输入为空！"
            allowLogin = false
        }else { // 不为空，继续判断用户名是否存在
            
            if self.resultsUserName?.count == 0 {
                userNameAlert.isHidden = false
                userNameAlert.text = "用户名不存在!"
                allowLogin = false
            }
            for i in 0..<(self.resultsUserName?.count)! {
                if resultsUserName?[i].userName == txtUser.text! {
                    allowLogin = true
                    break
                }else {
                    userNameAlert.isHidden = false
                    userNameAlert.text = "用户名不存在!"
                    allowLogin = false
                }
            }
            
        }
        
        if txtPwd.text == "" { // 判断用户密码输入是否为空
            pwdAlert.isHidden = false
            pwdAlert.text = "用户密码输入为空！"
            allowLogin = false
        }else { // 不为空，继续判断用户名是否存在
            for i in 0..<(self.resultsUserName?.count)! {
                if resultsUserName?[i].passWord == txtPwd.text! {
                    allowLogin = true
                    break
                }else {
                    pwdAlert.isHidden = false
                    pwdAlert.text = "密码错误!"
                    allowLogin = false
                }
            }
        }
        
        if allowLogin {
            
            let saveUserAccount = SaveAccount()
            
            saveUserAccount.saveAccount = txtUser.text!
            
//            print(saveUserAccount)
            
            try! realm.write {
                realm.add(saveUserAccount)
            }
            
            txtUser.text = ""
            txtPwd.text = ""
            userNameAlert.isHidden = true
            pwdAlert.isHidden = true
            let vc = TabBarController()
            vc.userAccount = txtUser.text!
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtPwd.resignFirstResponder()
        txtUser.resignFirstResponder()
        
        self.topConstraint?.update(offset: -80)
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
