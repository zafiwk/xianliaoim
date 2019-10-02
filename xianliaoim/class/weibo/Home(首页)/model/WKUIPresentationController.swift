//
//  WKUIPresentationController.swift
//  wk微博
//
//  Created by wangkang on 2018/4/12.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class WKUIPresentationController: UIPresentationController {
    
    
    var  presentedFrame :CGRect = CGRect.zero;
    
    private lazy var coverView:UIView = {
        let  view  =  UIView();
        view.backgroundColor = UIColor(white: 0.8, alpha: 0.2);
        view.frame = containerView!.bounds;
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapGRAction));
        view.addGestureRecognizer(tapGR);
        return view;
    }();
    
    override func containerViewWillLayoutSubviews(){
        //1.设置大小
//        presentedView?.frame = CGRect(x: 100, y: 55, width: 180, height: 250);
        
        presentedView?.frame=presentedFrame;
        //2.添加蒙版
        setupCoverView();
    }
}
extension WKUIPresentationController{
    private func setupCoverView(){
        containerView?.insertSubview(coverView, at: 0);
    }
    
    @objc private func  tapGRAction(){
        NSLog("tapGRAction");
        presentedViewController.dismiss(animated: true, completion: nil);
    }
}
