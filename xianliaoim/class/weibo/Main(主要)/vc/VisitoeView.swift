//
//  VisitoeView.swift
//  wk微博
//
//  Created by wangkang on 2018/4/11.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class VisitoeView: UIView {
    @IBOutlet weak var bgView: UIImageView!
    
    @IBOutlet weak var markImageView: UIImageView!
    
    @IBOutlet weak var loginBtn: UIButton!
    class func visitoeView() ->VisitoeView{
        return  Bundle.main.loadNibNamed("VisitoeView", owner: nil, options: nil)?.first as! VisitoeView
    }

    func  setupVisitoeView(title:String,imageName:String) {
        if title.count>0 {
            
        }
        if imageName.count>0 {
            markImageView.image = UIImage(named: imageName);
            bgView.isHidden = true;
        }
    }
    
    func  addRotationAnim()  {
        let  rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z");
        
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2;
        rotationAnim.repeatCount = MAXFLOAT;
        rotationAnim.duration = 5;
        rotationAnim.isRemovedOnCompletion = false;
        
        bgView.layer.add(rotationAnim, forKey: "rotationAnim");
        
    }
}
