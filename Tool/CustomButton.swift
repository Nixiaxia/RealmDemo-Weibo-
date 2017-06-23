//
//  CustomButton.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/3/17.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {
    
    var titleLB: UILabel!
    var numberLabel: UILabel!
    var number: Int!{
        didSet(oldValue){
            numberLabel.text = "\(self.number!)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func initWithProperty(titleString: String){
        
        titleLB = UILabel()
        numberLabel = UILabel()

        self.backgroundColor = UIColor.white
        
        // title
        titleLB.text = titleString
        titleLB.textColor = UIColor.darkGray
        titleLB.font = UIFont.systemFont(ofSize: 15)
        titleLB.textAlignment = .center
        self.addSubview(titleLB)
        titleLB.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(10)
            make.width.equalTo(boundsWidth/3)
            make.height.equalTo(30)
        }
        
        if number == nil {
            numberLabel.text = "0"
        }else {
            numberLabel.text = "\(number)"
        }        
        numberLabel.textColor = UIColor.black
        numberLabel.font = UIFont.boldSystemFont(ofSize: 15)
        numberLabel.textAlignment = .center
        self.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-10)
            make.width.equalTo(boundsWidth/3)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
