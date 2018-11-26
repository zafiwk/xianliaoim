//
//  ComposeTextView.swift
//  wk微博
//
//  Created by wangkang on 2018/4/23.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTextView: UITextView {

    lazy var placeHolderLabel : UILabel = UILabel()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupUI();
    }
    

}
//MARK: -设置UI界面
extension ComposeTextView{
    private func setupUI(){
        addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8);
            make.left.equalTo(10);
        }
        
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        placeHolderLabel.text = "分享新鲜事...";
        
        
        //设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7);
    }

    
}
