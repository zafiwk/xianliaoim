//
//  WelcomeVC.swift
//  wk微博
//
//  Created by wangkang on 2018/4/14.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import Kingfisher
class WelcomeVC: UIViewController {

    private  lazy var iconImgaView : UIImageView = {
        let iconImage:UIImageView = UIImageView();
        iconImage.image = UIImage(named: "avatar_default");
        iconImage.frame=CGRect(x: UIWidth/2.0-50, y: UIHeight-200, width: 100.0, height: 100.0);
        iconImage.kf.setImage(with: URL(string: (UserAccountViewModel.shareIntance.account?.avatar_large)!))
        iconImage.layer.masksToBounds = true;
        iconImage.layer.cornerRadius = 50.0;
        return iconImage;
    }();
    
    private lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "用户的登入名字"
        nameLabel.font = UIFont.systemFont(ofSize: 22);
        nameLabel.textAlignment = .center
        nameLabel.text = UserAccountViewModel.shareIntance.account?.screen_name;
        nameLabel.frame = CGRect(x: UIWidth/2.0-100, y: UIHeight/2.0+50, width: 200, height: 40);
        nameLabel.textColor = UIColor.orange
        return nameLabel;
    }()
    
    private lazy var bgimageView:UIImageView = {
        let imageView: UIImageView = UIImageView();
        imageView.frame = self.view.bounds;
        imageView.image = UIImage(named: "ad_background")
        return imageView;
        
    }();
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgimageView);
        view.addSubview(iconImgaView)
        view.addSubview(nameLabel)
        
    
        //执行动画
        //Damping :阻力系数，阻力系数越大。弹动效果越不明显
        //initialSpringVelocity 初始化系数
        UIView.animate(withDuration: 2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            self.iconImgaView.frame = CGRect(x:self.iconImgaView.getX(), y: UIHeight/2.0-50.0, width: 100.0, height: 100.0);
        }) { (_) in
//            UIApplication.shared.keyWindow?.rootViewController = MainViewController()
            
        }
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
