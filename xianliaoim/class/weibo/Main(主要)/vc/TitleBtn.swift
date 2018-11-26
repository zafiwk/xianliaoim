//
//  TitleBtn.swift
//  wk微博
//
//  Created by wangkang on 2018/4/12.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class TitleBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame);
        setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal);
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected);
        setTitleColor(UIColor.black, for: .normal);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重写布局就要重写这个方法
    override func layoutSubviews() {
        super.layoutSubviews();
//        swift中能直接结构体中赋值
//        let  rect   = titleLabel!.frame;
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width+10;
        
    }
}
