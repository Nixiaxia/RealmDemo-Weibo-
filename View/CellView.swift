//
//  CellView.swift
//  OC -> Swift
//
//  Created by 逆夏夏 on 2017/1/11.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit

class cellView: UIView {

    var cellImage: UIImageView!
    var leftNameLB: UILabel!
    var rightNameLB: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellImage = UIImageView()
        leftNameLB = UILabel()
        rightNameLB = UILabel()
    }
    
    func initWithFrame(image: String, leftName: String, rightName: String?) {

        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = appDGrayColor.cgColor//UIColor.darkGrayColor().CGColor
        
        cellImage.image = UIImage.init(named: image)?.scaleImage(scaleSize: 0.5)
        self.addSubview(cellImage)
        cellImage.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self)
        }
        
        leftNameLB.text = leftName
        self.addSubview(leftNameLB)
        leftNameLB.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(cellImage.snp.right).offset(10)
            make.bottom.equalTo(0)
            make.width.equalTo(boundsWidth*12/60)
        }

        let button = UIImageView()
        button.image = UIImage.init(named: "rightButton")?.scaleImage(scaleSize: 0.7)
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.equalTo(self)
        }
        
        if rightName != nil {
            rightNameLB.text = rightName
            rightNameLB.textAlignment = .right
            rightNameLB.font = UIFont.systemFont(ofSize: 15)
            rightNameLB.textColor = UIColor.darkGray
            self.addSubview(rightNameLB)
            rightNameLB.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                make.right.equalTo(button.snp.left)
                make.width.equalTo((boundsWidth*34/60))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
