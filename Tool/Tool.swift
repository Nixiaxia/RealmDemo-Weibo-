//
//  Tool.swift
//  UI
//
//  Created by 逆夏夏 on 2017/1/4.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import Foundation

// 获取屏幕宽
let boundsWidth = UIScreen.main.bounds.width
// 获取屏幕高
let boundsHeight = UIScreen.main.bounds.height

// 背景颜色(灰色)
let appDGrayColor = UIColor.init(red: 0.9451, green: 0.9451, blue: 0.9451, alpha: 1)
// 背景颜色(蓝色)
let appBlueColor = UIColor(red: 1/255, green: 170/255, blue: 235/255, alpha: 1)

// 正则表达式工具类
struct MyRegex {
    let regex: NSRegularExpression?
    
    init(pattern: String) {
        regex = try? NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }else {
            return false
        }
    }
    
}

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize.init(width: (self.size.width)*scaleSize, height: (self.size.height)*scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
}

///label高度自适应
///
/// - Parameters:
///   - text: 文字
///   - labelWidth: 最大宽度
///   - attributes: 字体，行距等
/// - Returns: 高度
func autoLabelHeight(with text:String , labelWidth: CGFloat ,attributes : UIFont) -> CGFloat{
    var size = CGRect()
    let size2 = CGSize(width: labelWidth, height: 0)//设置label的最大宽度
    let size3 = [NSFontAttributeName: attributes]
    size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: size3 , context: nil);
    return size.size.height
}

// 底部文字提示
func showHUD(text: String, to: UIView!) {
    let hud = MBProgressHUD.showAdded(to: to, animated: true)
    hud?.mode = MBProgressHUDModeText
    hud?.labelText = text
    hud?.margin = 10
    hud?.yOffset = Float(boundsHeight * 0.3)
    hud?.removeFromSuperViewOnHide = true
    hud?.hide(true, afterDelay: 3)
}

// 获取当前时间
public func currentTime() -> String {
    
    let date = NSDate()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "yyyy-M-d HH:mm:ss"
    let strNowTime = timeFormatter.string(from: date as Date) as String
    
    return strNowTime
    
}
