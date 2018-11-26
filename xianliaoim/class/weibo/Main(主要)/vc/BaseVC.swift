//
//  BaseVC.swift
//  wk微博
//
//  Created by wangkang on 2018/4/11.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class BaseVC: UITableViewController {

    
    var isLogin:Bool = UserAccountViewModel.shareIntance.isLogin;
    
    var  visitoeView:VisitoeView?
    
    override func loadView() {
        if !isLogin {
            self.setupVisitoeView();
            return
        }
        super.loadView();
        self.view.backgroundColor = UIColor.white;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    
}

extension BaseVC{
    private func setupVisitoeView(){
        let view = VisitoeView.visitoeView();
        self.visitoeView = view;
        self.view = view;
        visitoeView?.loginBtn.addTarget(self, action: #selector(userLogin), for: .touchUpInside);
    }
    
    @objc private func userLogin(){
        let loginVC = LoginVC()
        present(UINavigationController(rootViewController: loginVC), animated: true, completion: nil);
        
        
    }
}
