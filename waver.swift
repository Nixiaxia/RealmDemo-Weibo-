//
//  waver.swift
//  OC -> Swift
//
//  Created by 逆夏夏 on 2017/1/11.
//  Copyright © 2017年 逆夏夏. All rights reserved.
//

import UIKit
import QuartzCore

class WaveView: UIView {
    
    // 波浪曲线： y = h * sin(a * x + b); h: 波浪高度， a: 波浪宽度系数， b： 波的位移
    // 波浪高度h
    var waveHeight:CGFloat = 10
    // 波浪宽 a
    var waveRate:CGFloat = 0.01
    // 波浪速度
    var waveSpeed1:CGFloat = 0.05
    var waveSpeed2:CGFloat = 0.02
    
    // 真实波浪颜色
    var realWaveColor: UIColor = UIColor.white
    // 阴影波浪颜色
    var maskWaveColor: UIColor = UIColor(white: 0.8, alpha: 0.3)
    
    var closure: ((_ centerY: CGFloat)->())?
    
    private var displayLink: CADisplayLink?
    
    private var realWaveLayer: CAShapeLayer?
    private var maskWaveLayer: CAShapeLayer?
    
    private var offset1: CGFloat = 0
    private var offset2: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWaveParame()
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWaveParame()
        
        self.backgroundColor = UIColor.clear
    }
    
    private func initWaveParame() {
        
        // 真实波浪配置
        realWaveLayer = CAShapeLayer()
//        var frame = bounds
//        realWaveLayer?.frame.origin.y = frame.size.height - waveHeight
//        frame.size.height = waveHeight
//        realWaveLayer?.frame = frame
        
        // 阴影波浪配置
        maskWaveLayer = CAShapeLayer()
//        maskWaveLayer?.frame.origin.y = frame.size.height - waveHeight
//        frame.size.height = waveHeight
//        maskWaveLayer?.frame = frame
        
        layer.addSublayer(maskWaveLayer!)
        layer.addSublayer(realWaveLayer!)
    }
    
    func startWave() {
        displayLink = CADisplayLink(target: self, selector: #selector(self.wave))
        displayLink!.add(to: RunLoop.current, forMode: RunLoopMode.commonModes);
    }
    
    func endWave() {
        displayLink!.invalidate()
        displayLink = nil
    }
    
    func wave() {
        // 波浪移动的关键：按照指定的速度偏移
        offset1 += waveSpeed1
        offset2 += waveSpeed2
        
        // 从左下角开始
        let realPath = UIBezierPath()
        realPath.move(to: CGPoint(x: 0, y: frame.size.height))
        
        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint(x: 0, y: frame.size.height))
        
        var x = CGFloat(0)
        var y1 = CGFloat(0)
        var y2 = CGFloat(0)
        
        while x <= bounds.size.width {
            // 波浪曲线
            y1 = waveHeight * sin(x * waveRate + offset1)
            y2 = waveHeight * sin(x * waveRate + offset2)
            
            realPath.addLine(to: CGPoint(x: x, y: y1))
            maskPath.addLine(to: CGPoint(x: x, y: -y2))
            
            // 增量越小，曲线越平滑
            x += 0.1
        }
        
        let midX = bounds.size.width * 0.5
        let midY = waveHeight * sin(midX * waveRate + offset1)
        
        if let closureBack = closure {
            closureBack(
                midY)
        }
        // 回到右下角
        realPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        maskPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        
        // 闭合曲线
//        maskPath.closePath()
        
        // 把封闭图形的路径赋值给CAShapeLayer
        maskWaveLayer?.path = maskPath.cgPath
        maskWaveLayer?.lineWidth = 2
        maskWaveLayer?.fillColor = UIColor.clear.cgColor
        maskWaveLayer?.strokeColor = appDGrayColor.cgColor
        
        realPath.close()
        realWaveLayer?.path = realPath.cgPath
        realWaveLayer?.lineWidth = 2
        realWaveLayer?.strokeColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).cgColor
        realWaveLayer?.fillColor = UIColor.clear.cgColor
    }
    
    
}
