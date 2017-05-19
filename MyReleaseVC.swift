//
//  MyReleaseVC.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/3/17.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import MJRefresh
import RealmSwift

class MyReleaseVC: UIViewController {
    
    let realm = try! Realm()
    
    var tableView: UITableView!
    var currPage = 0
    var consumeItems = [MainPageModel]()
    var item = MainPageModel()
    var consumeItemsArray = [MainPageModel]() // 分页需要一个数组
    
    var currentID = SaveAccount() // 储存当前登陆用户ID

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "我的发布"
        
        createUI()
        
        download()
    }
    
    func createUI() {
        tableView = UITableView()
        tableView.separatorStyle = .none // 取消之间的间隔线
        tableView.backgroundColor = appDGrayColor
        tableView.frame = self.view.bounds
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(MainPageCell.self, forCellReuseIdentifier: "mainPageCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(updataRefresh))
        // 上拉加载
        tableView.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
    }
    
    // 上拉加载
    func loadMoreData() {
        
        if currPage != (consumeItems.count) { // 判断当前页数是否等于主页的数据
            
            if (currPage + 5) < (consumeItems.count) { // 判断加5页后是否小于当前主页数据
                for i in currPage..<(currPage + 5) {
                    consumeItemsArray.append((consumeItems[i]))
                }
                currPage += 5
            }else {
                
                if (consumeItems.count) == 0 {
                    return
                }else {
                    for i in currPage..<(consumeItems.count) {
                        consumeItemsArray.append((consumeItems[i]))
                    }
                    currPage = (consumeItems.count)
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
        download()
        sleep(1)
        tableView.reloadData()
        self.tableView.mj_header.endRefreshing()
    }
    
    // 下载数据的方法
    func download() {
        
        consumeItemsArray.removeAll()
        currPage = 5 // 设置下载的页数
        
//        consumeItems = realm.objects(MainPageModel.self).sorted(byKeyPath: "time", ascending: false) // 抽取主页的数据，按照时间降序排列
        
        if consumeItems.count >= currPage  { // 如果主页中的数据大于设置的页数
            for i in 0..<currPage { // 先抽取前5页数据
                consumeItemsArray.append((consumeItems[i])) // 加入到数组
                currPage = i
            }
            currPage += 1 // 完成后页数要+1
        }else {
            for i in 0..<(consumeItems.count) {
                consumeItemsArray.append((consumeItems[i]))
                currPage = i
            }
            currPage += 1
        }
        
        // 下载当前登陆用户ID
        let saveAccount = try! Realm().objects(SaveAccount.self)
        currentID = saveAccount.first!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.mj_header.beginRefreshing()
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

extension MyReleaseVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // section
        if self.consumeItems.count != 0  {
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
        
        if consumeItems.count != 0 {
            
            item = self.consumeItemsArray[indexPath.row] // 获取是第几个cell
            
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
            cell.praiseClickBack = {(num, bool,ID) in // 点赞button回调
                
                if bool == false { // 此时是取消点赞的回调bool值
                    
                    for i in 0..<self.item.praisePeople.count {
                        if self.item.praisePeople[i].praiseName == self.currentID.saveAccount {// 找到当前登陆用户
                            try! self.realm.write {
                                self.realm.delete(self.item.praisePeople[i])// 从点赞用户里面删除
                            }
                            break // break，不然会数组越界
                        }
                    }
                    
                    try! self.realm.write {// 更新数据库的数据
                        self.item.praiseNumber = num
                        self.item.praiseFalse = false
                    }
                    
                }else { // 此时是点赞后传过来的bool值
                    let praisePeople = PraisePeople()
                    praisePeople.praiseName = self.currentID.saveAccount // 将当前登陆用户传值给praisePeople
                    try! self.realm.write { // 更新数据库
                        self.item.praiseNumber = num
                        self.item.praiseFalse = true
                        self.item.praisePeople.append(praisePeople) // 把当前登陆用户储存到点赞的数据库中
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
