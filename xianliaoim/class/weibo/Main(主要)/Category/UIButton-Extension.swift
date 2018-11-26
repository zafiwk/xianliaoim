//
//  UIBtnTools.swift
//  wk微博
//
//  Created by wangkang on 2018/4/11.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
extension UIButton{
    //    class func createButton(image:String  , bgImageName:String) ->UIButton{
    //        let  btn = UIButton();
    //        btn.setBackgroundImage(UIImage(named: bgImageName+"_highlighted"), for: .highlighted);
    //        btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal);
    //        btn.setImage(UIImage(named: image), for: .normal);
    //        btn.setImage(UIImage(named: image+"_highlighted"), for: .highlighted);
    //        return  btn;
    //    }
    //遍历构造函数，常用在对系统类进行构造函数的扩展使用 通常写在扩展中
    convenience init(image:String  , bgImageName:String){
        self.init(); //必须明确的调用self.init
        self.setBackgroundImage(UIImage(named: bgImageName+"_highlighted"), for: .highlighted);
        self.setBackgroundImage(UIImage(named: bgImageName), for: .normal);
        self.setImage(UIImage(named: image), for: .normal);
        self.setImage(UIImage(named: image+"_highlighted"), for: .highlighted);
        
    }
    
    convenience init(imageName:String){
        self.init();
        self.setImage(UIImage(named: imageName), for: .normal);
        self.setImage(UIImage(named: imageName+"_highlighted"), for: .highlighted);
        self.sizeToFit();
    }
    
    
    convenience init(bgColor:UIColor ,fontSize:CGFloat ,title:String){
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}
