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
    
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @objc class func visitoeView() ->VisitoeView{
        let view  =  Bundle.main.loadNibNamed("VisitoeView", owner: nil, options: nil)?.first as! VisitoeView
        view.loginBtn.setTitle(NSLocalizedString("登录", comment: ""), for: UIControl.State.normal);
        return view;
    }

    @objc func  setupVisitoeView(title:String,imageName:String) {
        if title.count>0 {
            self.messageTitle.text=title;
        }
        if imageName.count>0 {
            markImageView.image = UIImage(named: imageName);
            bgView.isHidden = true;
        }
    }
    
   @objc func  addRotationAnim()  {
        let  rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z");
        
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2;
        rotationAnim.repeatCount = MAXFLOAT;
        rotationAnim.duration = 5;
        rotationAnim.isRemovedOnCompletion = false;
        
        bgView.layer.add(rotationAnim, forKey: "rotationAnim");
        
    }
}
