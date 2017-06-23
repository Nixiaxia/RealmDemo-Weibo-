//
//  AttentionPeople.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/5/5.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import RealmSwift

class AttentionPeopleVC: UIViewController {
    
    let realm = try! Realm()
    
    var itemFoucs = [AttentionPeople]() // 接收上个页面的数据如果是点击的是关注
    var itemFans = [FansPeople]() // 接收上个页面的数据如果是点击的是粉丝
    var tableView: UITableView! //
    
    var itemFoucsArray = [UserInfo]()
    
    var isFoucs = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        if isFoucs {
            self.title = "Ta的关注"
        }else {
            self.title = "Ta的粉丝"
        }

        download()
        
        createUI()
        
    }
    
    func download() {
        // 准备数据
        let userAccount = realm.objects(UserInfo.self)
        if isFoucs {
            for i in itemFoucs {
                for j in userAccount {
                    if i.userAttentionName == j.userNickname {
                        itemFoucsArray.append(j)
                    }
                }
            }
        }else {
            for i in itemFans {
                for j in userAccount {
                    if i.fansPeopleName == j.userNickname {
                        itemFoucsArray.append(j)
                    }
                }
            }
        }
    }
    
    func createUI() {
        // 底层tableview
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.frame = self.view.bounds
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PraiseCell.self, forCellReuseIdentifier: "praiseCell")
        self.view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false        
        self.tabBarController?.tabBar.isHidden = true
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

extension AttentionPeopleVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFoucs {
            return itemFoucs.count
        }else {
            return itemFans.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PraiseCell = tableView.dequeueReusableCell(withIdentifier: "praiseCell") as! PraiseCell // cell复用
        
        cell.configerMainPageCell(model: itemFoucsArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var userInfor = ""
        
        let userInfoAccount = realm.objects(User.self)
        
        for i in userInfoAccount {
            if itemFoucsArray[indexPath.row].userNickname == i.userInfo?.userNickname {
                userInfor = i.userName
            }
        }
        
        let vc = UserDetailVC()
        vc.userAccount = userInfor
        self.navigationController?.pushViewController(vc, animated: true)
   
    }
}
