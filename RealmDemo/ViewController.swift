////
////  ViewController.swift
////  RealmDemo
////
////  Created by 逆夏夏 on 2017/1/23.
////  Copyright © 2017年 逆夏夏. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//import SnapKit
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    // 使用默认的数据库
//    var realm = try! Realm()
//    
//    // 建立tableView
//    var tableView: UITableView!
//    
//    var dformatter = DateFormatter()
//    
//    // 保存从数据库中查询出来的结果集
//    var consumeItems: Results<ConsumeItem>?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        self.view.backgroundColor = UIColor.white
//
//        // 打印出数据库地址
//        print(realm.configuration.fileURL!)
//        
//        self.dformatter.dateFormat = "MM月dd日 HH:mm"
//        
//        
////        createData()
//        
////        createTableView()
//        
//    }
//    
//    func createTableView() {
//        tableView = UITableView()
//        tableView.frame = self.view.bounds
//        self.view.addSubview(tableView)
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
//        
//        // 查询所有的消费记录
//        consumeItems = realm.objects(ConsumeItem.self)
//        
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.consumeItems!.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "MyCell")
//        let item = self.consumeItems![indexPath.row]
//        cell.textLabel?.text = item.name + " $" + String.init(format: "%.1f", item.cost)
//        cell.detailTextLabel?.text = self.dformatter.string(from: item.date)
//        return cell
//    }
//    
//    func createData() {
//        
//        // 查询所有的消费记录
//        let items = realm.objects(ConsumeItem.self)
//        // 已经有记录的话就不插入了
//        if (items.count) > 0 {
//            return
//        }
//        
//        // 创建两个消费类型
//        let type1 = ConsumeType()
//        type1.name = "购物"
//        let type2 = ConsumeType()
//        type2.name = "娱乐"
//        
//        // 创建三个消费记录
//        let item1 = ConsumeItem(value: ["买一台电脑",5999.00,Date(),type1]) // 可使用数组创建
//        
//        let item2 = ConsumeItem()
//        item2.name = "看一场电影"
//        item2.cost = 30.00
//        item2.date = Date.init(timeIntervalSinceNow: -36000)
//        item2.type = type2
//        
//        let item3 = ConsumeItem()
//        item3.name = "买一包泡面"
//        item3.cost = 2.50
//        item3.date = Date.init(timeIntervalSinceNow: -72000)
//        item3.type = type1
//        
//        // 数据持久化操作（类型记录也会自动添加的）
//        try! realm.write {
//            realm.add(item1)
//            realm.add(item2)
//            realm.add(item3)
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
