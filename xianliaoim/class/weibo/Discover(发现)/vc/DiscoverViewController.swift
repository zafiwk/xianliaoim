//
//  DiscoverViewController.swift
//  wk微博
//
//  Created by wangkang on 2018/4/10.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.visitoeView?.setupVisitoeView(title: "", imageName: "visitordiscover_image_message");
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
