//
//  ProgressView.swift
//  wk微博
//
//  Created by wangkang on 2018/4/29.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    var progress : CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func draw(_ rect: CGRect) {
        super.draw(rect);
        let center = CGPoint(x: rect.width*0.5, y: rect.height*0.5)
        let radius = rect.width*0.5-3
        let startAngle = CGFloat(-Double.pi/2.0)
        let endAngle = CGFloat(2 * Double.pi) * progress + startAngle
        
        // 创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // 绘制一条中心点的线
        path.addLine(to: center)
        path.close()
        
        // 设置绘制的颜色
        UIColor(white: 1.0, alpha: 0.4).setFill()
        
        // 开始绘制
        path.fill()
        
    }
}
