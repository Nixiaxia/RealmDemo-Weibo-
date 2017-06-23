//
//  UserDetailVC.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/4/9.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import RealmSwift
import MJRefresh

class UserDetailVC: UIViewController {
    
    let realm = try! Realm()
    
    var userAccount = "" // 获取跳转过来的账号
    var userCurrentNickname = "" // 获取跳转过来的昵称
    
    var currentUserInfo: UserInfo! // 跳转过来的账号的信息
    
    var tableView: UITableView!
    private var headView: UIView! // tableView的头视图

    private var headImageView: UIImageView! // 头部头像
    private var headNameLB: UILabel! // 头部姓名
    private var headNumberLB: UILabel! // 头部电话
    private var waverView: UIView! // 波浪

    private var focus: CustomUIButton! // 关注
    private var fans: CustomUIButton! // 粉丝
    
    private var bottomFoucsButton: UIButton! // 底部关注按钮
    
    var currPage = 0
    var consumeItems: Results<MainPageModel>? // 获取数据库模型对应的数据
//    var item = MainPageModel()
    var consumeCurrentItems = [MainPageModel]() // 把当前用户的数据从consumeItems里面抽取取出来
    var consumeItemsArray = [MainPageModel]() // 分页需要一个数组
    
    var currentID = SaveAccount() // 储存当前登陆用户ID
    var currentIDAsString = "" // 储存当前登陆用户ID string 格式
    var currnetNicknameString = "" // 储存当前登陆用户昵称 string 格式
    
    var currentLoginInfo: UserInfo! // 当前登陆用户信息

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = appDGrayColor
        
        download()
  
        createUI() // 创建UI
    
        createBackButton() // 自定义返回按钮
    }
    
    // 下载数据的方法
    func download() {
        
        consumeItemsArray.removeAll()
        currPage = 5 // 设置下载的页数
        
        consumeItems = realm.objects(MainPageModel.self).sorted(byKeyPath: "time", ascending: false) // 抽取主页的数据，按照时间降序排列
        
        // 把当前用户的数据从consumeItems里面抽取取出来
        if consumeItems?.count != 0 {
            for i in consumeItems! {
                if userAccount == i.accountID {
                    consumeCurrentItems.append(i)
                }
            }
        }
        
        if consumeCurrentItems.count >= currPage  { // 如果主页中的数据大于设置的页数
            for i in 0..<currPage { // 先抽取前5页数据
                consumeItemsArray.append((consumeCurrentItems[i])) // 加入到数组
                currPage = i
            }
            currPage += 1 // 完成后页数要+1
        }else {
            for i in 0..<(consumeCurrentItems.count) {
                consumeItemsArray.append((consumeCurrentItems[i]))
                currPage = i
            }
            currPage += 1
        }
        
        // 下载当前登陆用户ID
        let saveAccount = try! Realm().objects(SaveAccount.self)
        currentID = saveAccount.first!
        
        // 获取当前登陆用户ID
        currentIDAsString = currentUserID()
        // 获取当前登陆用户昵称
        currnetNicknameString = currentUserNickname()
        
        // 找到当前登陆用户的信息
        let userInfoAll = try! Realm().objects(User.self)
        currentLoginInfo = UserInfo()
        for i in userInfoAll {
            if currentIDAsString == i.userName {
                currentLoginInfo = i.userInfo!
                break
            }
        }
        
    }
    
    // 上拉加载
    func loadMoreData() {
        
//        print(consumeItems.count)
        
        if currPage != (consumeCurrentItems.count) { // 判断当前页数是否等于主页的数据
            
            if (currPage + 5) < (consumeCurrentItems.count) { // 判断加5页后是否小于当前主页数据
                for i in currPage..<(currPage + 5) {
                    consumeItemsArray.append((consumeCurrentItems[i]))
                }
                currPage += 5
            }else {
                
                if (consumeCurrentItems.count) == 0 {
                    return
                }else {
                    for i in currPage..<(consumeCurrentItems.count) {
                        consumeItemsArray.append((consumeCurrentItems[i]))
                    }
                    currPage = (consumeCurrentItems.count)
                }
            }
            
        }else {
            
            self.tableView.mj_footer.endRefreshing()
            return
        }
        
        tableView.reloadData()
        
        self.tableView.mj_footer.endRefreshing()
    }
    
    // 下拉刷新响应方法
    func updataRefresh() {
        consumeItemsArray.removeAll()
        consumeCurrentItems.removeAll()
        download()
        sleep(1)
        tableView.reloadData()
        self.tableView.mj_header.endRefreshing()
    }
    
    func createUI() {
        
        // 准备数据
        let userInfoAll = try! Realm().objects(User.self)
        // 找到这个用户
        currentUserInfo = UserInfo()
        for i in userInfoAll {
            if userAccount == i.userName {
                currentUserInfo = i.userInfo!
                userCurrentNickname = (i.userInfo?.userNickname)!
                break
            }
        }
        
        // 循环遍历粉丝自己是否关注此人，如果关注了，foucsBool为true
        for i in currentUserInfo.fansPeople {
            if currnetNicknameString == i.fansPeopleName {
                try! realm.write {
                    currentUserInfo.foucsBool = true
                }
                break
            }else {
                try! realm.write {
                    currentUserInfo.foucsBool = false
                }
            }
        }
        
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(MainPageCell.self, forCellReuseIdentifier: "mainPageCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = appDGrayColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(-20)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-50)
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(updataRefresh))
        // 上拉加载
        tableView.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        
        headView = UIView()
        headView.backgroundColor = UIColor.white
        headView.frame = CGRect.init(x: 0, y: 0, width: boundsWidth, height: 290)
        tableView.tableHeaderView = headView
        
        headImageView = UIImageView()
        if currentUserInfo.image != nil {
            headImageView.image = UIImage.init(data: currentUserInfo.image as! Data)
        }else {
            headImageView.image = UIImage.init(named: "个人")
        }
        
        headImageView.layer.cornerRadius = 35
        headImageView.layer.masksToBounds = true
        headImageView.layer.borderWidth = 2
        headImageView.layer.borderColor = appDGrayColor.cgColor
        headView.addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.centerX.equalTo(headView)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        // 头部姓名
        headNameLB = UILabel()
        headNameLB.textAlignment = .center
        headNameLB.text = currentUserInfo.userNickname
        headView.addSubview(headNameLB)
        headNameLB.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView.snp.bottom).offset(5)
            make.centerX.equalTo(headView)
            make.width.equalTo(boundsWidth)
            make.height.equalTo(30)
        }
        
        // 头部账号
        headNumberLB = UILabel()
        headNumberLB.font = UIFont.systemFont(ofSize: 14)
        headNumberLB.text = userAccount
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
        
        // 关注
        focus = CustomUIButton()
        focus.initWithProperty(titleString: "关注")
        focus.number = currentUserInfo.attentionPeople.count
        headView.addSubview(focus)
        focus.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(waverView.snp.bottom).offset(25)
            make.width.equalTo(boundsWidth/2)
            make.height.equalTo(55)
        }
        focus.addTarget(self, action: #selector(focusAction), for: .touchUpInside)
        
        // 粉丝
        fans = CustomUIButton()
        fans.initWithProperty(titleString: "粉丝")
        fans.number = currentUserInfo.fansPeople.count
        headView.addSubview(fans)
        fans.snp.makeConstraints { (make) in
            make.left.equalTo(focus.snp.right)
            make.top.equalTo(waverView.snp.bottom).offset(25)
            make.width.equalTo(boundsWidth/2)
            make.height.equalTo(55)
        }
        fans.addTarget(self, action: #selector(fansAction), for: .touchUpInside)
        
        // headView底下灰色的线
        let bottomLine = UILabel()
        bottomLine.backgroundColor = appDGrayColor
        headView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(focus.snp.bottom)
            make.height.equalTo(2)
            make.width.equalTo(boundsWidth)
            make.bottom.equalTo(headView)
        }
        
        // 底部关注按钮
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
        bottomsTopLine.backgroundColor = UIColor.darkGray
        bottomView.addSubview(bottomsTopLine)
        bottomsTopLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(bottomView.snp.centerX)
            make.height.equalTo(2)
            make.width.equalTo(boundsWidth)
        }
        
        // 底部关注
        bottomFoucsButton = UIButton()
        if userAccount == currentIDAsString {
            bottomFoucsButton.setTitle("自己不能关注自己噢～", for: .normal)
            bottomFoucsButton.setTitleColor(UIColor.orange, for: .normal)
            bottomFoucsButton.isEnabled = false
        }else {
            if currentUserInfo.foucsBool {
                bottomFoucsButton.setTitle("已关注", for: .normal)
                bottomFoucsButton.setTitleColor(UIColor.orange, for: .normal)
                bottomFoucsButton.isEnabled = true
            }else {
                bottomFoucsButton.setTitle("+ 关注", for: .normal)
                bottomFoucsButton.setTitleColor(UIColor.darkGray, for: .normal)
                bottomFoucsButton.isEnabled = true
            }
        }
        bottomView.addSubview(bottomFoucsButton)
        bottomFoucsButton.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        bottomFoucsButton.addTarget(self, action: #selector(bottomFoucsButtonAction), for: .touchUpInside)
    }
    
    // 底部关注按钮
    func bottomFoucsButtonAction() {
        
        let timeInterval_1 = NSDate().timeIntervalSince1970 * 100
        let timeInterval_2 = NSDate().timeIntervalSince1970 * 10
        
        let fansPeopleName = FansPeople()
        fansPeopleName.fansPeopleName = currnetNicknameString
        fansPeopleName.fansPeopleNameID = Int(timeInterval_1)
        
        let attentionPeopleName = AttentionPeople()
        attentionPeopleName.userAttentionName = userCurrentNickname
        attentionPeopleName.userAttentionNameID = Int(timeInterval_2)

        if currentUserInfo.foucsBool {
            for i in 0..<currentUserInfo.fansPeople.count {
                if currnetNicknameString == currentUserInfo.fansPeople[i].fansPeopleName {
                    try! realm.write {
                        // 页面用户信息操作
                        realm.delete(currentUserInfo.fansPeople[i])
                        currentUserInfo.foucsBool = false
                    }
                    bottomFoucsButton.setTitle("+ 关注", for: .normal)
                    bottomFoucsButton.setTitleColor(UIColor.darkGray, for: .normal)
                    fans.number = currentUserInfo.fansPeople.count // 刷新粉丝数量
                    tableView.mj_header.beginRefreshing()
                    break
                }
            }
            
            for i in 0..<currentLoginInfo.attentionPeople.count {
                if userCurrentNickname == currentLoginInfo.attentionPeople[i].userAttentionName {
                    try! realm.write {
                        realm.delete(currentLoginInfo.attentionPeople[i])
                    }
                    break
                }
            }
        }else {
            try! realm.write {
                // 当前页面用户操作信息
                currentUserInfo.fansPeople.append(fansPeopleName)
                currentUserInfo.foucsBool = true
                // 当前登陆用户操作信息
                currentLoginInfo.attentionPeople.append(attentionPeopleName)
            }
            bottomFoucsButton.setTitle("已关注", for: .normal)
            bottomFoucsButton.setTitleColor(UIColor.orange, for: .normal)
            fans.number = currentUserInfo.fansPeople.count // 刷新粉丝数量
            tableView.mj_header.beginRefreshing()
        }
    }
    
    // 点击“关注”方法
    func focusAction() {
        let vc = AttentionPeopleVC()
        var itemArray = [AttentionPeople]()
        for i in currentUserInfo.attentionPeople {
            itemArray.append(i)
        }
        vc.itemFoucs = itemArray
        vc.isFoucs = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击“粉丝”方法
    func fansAction() {
        let vc = AttentionPeopleVC()
        var itemArray = [FansPeople]()
        for i in currentUserInfo.fansPeople {
            itemArray.append(i)
        }
        vc.itemFans = itemArray
        vc.isFoucs = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func createWaver() {
        
        let waveView_1 = WaveView.init(frame: CGRect.init(x: -5, y: 15, width: boundsWidth+10, height: 10+30))//.init(frame: CGRectMake(-5, 15, boundsWidth+10, 10+(headHeight)*30/290))
        
        waverView.addSubview(waveView_1)
        
        waveView_1.startWave()
        
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
    
    // 返回按钮事件
    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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

extension UserDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.consumeItems?.count != 0  {
            return self.consumeItemsArray.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // cell赋值
        
        let cell: MainPageCell = tableView.dequeueReusableCell(withIdentifier: "mainPageCell") as! MainPageCell // cell复用
        
        // 滑出屏幕删除cell，避免复用混乱
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        if consumeItems?.count != 0 {
            
            let item = self.consumeItemsArray[indexPath.row] // 获取是第几个cell
            
            // 判断点赞人数
            if item.praisePeople.count == 0 { // 如果等于0，说明没人点赞
                try! self.realm.write {
                    item.praiseNumber = 0
                    item.praiseFalse = false
                }
                
            }else {
                for i in 0..<item.praisePeople.count {// 循环点赞人数
                    
                    if item.praisePeople[i].praiseName == self.currentID.saveAccount {// 如果点赞人里面有当前登陆用户
                        try! self.realm.write { // 点赞button为已点赞
                            item.praiseFalse = true
                        }
                        break // break，不然会数组越界
                    }else {
                        //                        let praisePeople = PraisePeople()
                        //                        praisePeople.praiseName = self.currentID.saveAccount
                        try! self.realm.write {
                            item.praiseFalse = false // 说明没有点赞
                            //                            item.praisePeople.append(praisePeople)
                        }
                    }
                }
            }
            
            // 点赞续+1
            cell.praiseClickBack = {(num, bool,myitem) in // 点赞button回调
                
                if bool == false { // 此时是取消点赞的回调bool值
                    
                    for i in 0..<item.praisePeople.count {
                        if item.praisePeople[i].praiseName == self.currentID.saveAccount {// 找到当前登陆用户
                            try! self.realm.write {
                                self.realm.delete(item.praisePeople[i])// 从点赞用户里面删除
                            }
                            break // break，不然会数组越界
                        }
                    }
                    
                    try! self.realm.write {// 更新数据库的数据
                        myitem.praiseNumber = num
                        myitem.praiseFalse = false
                        self.realm.add(myitem, update: true)
                    }
                    
                }else { // 此时是点赞后传过来的bool值
                    let praisePeople = PraisePeople()
                    praisePeople.praiseName = self.currentID.saveAccount // 将当前登陆用户传值给praisePeople
                    try! self.realm.write { // 更新数据库
                        myitem.praiseNumber = num
                        myitem.praiseFalse = true
                        myitem.praisePeople.append(praisePeople) // 把当前登陆用户储存到点赞的数据库中
                        self.realm.add(myitem, update: true)
                    }
                }
            }
            
            cell.configerMainPageCell(model: item) // 调用cell方法，给cell赋值
            
            cell.commentClickBack = {
                let clickBlock = self.consumeItemsArray[indexPath.row]
                let vc = MainPageCellDetails()
                vc.item = clickBlock
                vc.commentOrDidSelect = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return cell
            
        }else {
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableview的点击动画
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = MainPageCellDetails()
        // 点击的数据，要穿到下一页面
        let clickBlock = self.consumeItemsArray[indexPath.row]
        
        vc.item = clickBlock
        // 当跳到下一页面，下面的tabbar隐藏
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
