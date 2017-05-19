
//
//  MainPageCollectionCell.swift
//  RealmDemo
//
//  Created by 逆夏夏 on 2017/3/13.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit

class MainPageCollectionCell: UICollectionViewCell {
    
    var images = UIImageView()
    
    var imageBlock: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        images = UIImageView()
        images.image = UIImage.init(named: "testName")
        self.contentView.addSubview(images)
        images.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
    }
    
    func configModel(model: MainPagePhotos) {

        if model.image == nil {
            images.image = nil
        }else {
            let imageData = model.image
            images.image = UIImage.init(data: imageData as! Data)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainPageCollectionCell {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        imageBlock!()
    }
}
