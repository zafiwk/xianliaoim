//
//  ProfileViewController.swift
//  wk微博
//
//  Created by wangkang on 2018/4/10.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class ProfileViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.visitoeView?.setupVisitoeView(title: "", imageName: "visitordiscover_image_profile");
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注销", style: .plain, target: self, action: #selector(loginOut));
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loginOut(){
        let  path =  UserAccountViewModel.shareIntance.accountPath;
        guard (try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))) != nil else {
            return
        }  ;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
