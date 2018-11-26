//
//  ComposeTitleView.swift
//  wk微博
//
//  Created by wangkang on 2018/4/23.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class ComposeTitleView: UIView {
    private lazy var titleLabel : UILabel  = UILabel()
    private lazy var screenNameLabel : UILabel = UILabel()

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder);
//        setupUI();
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI界面
extension ComposeTitleView{
    private func  setupUI(){
        addSubview(titleLabel);
        addSubview(screenNameLabel);
        
        //2 设置frame
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self);
            make.top.equalTo(self);
        }

        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp.centerX);
            make.top.equalTo(titleLabel.snp.bottom).offset(3);
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareIntance.account?.screen_name
    }
}
