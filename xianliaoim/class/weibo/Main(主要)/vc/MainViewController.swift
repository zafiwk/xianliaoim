//
//  MainViewController.swift
//  wk微博
//
//  Created by wangkang on 2018/4/10.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    private lazy  var  composeBtn :UIButton = {
        let btn = UIButton(image: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button");
//        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted);
//        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal);
//        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal);
//        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted);
        btn.sizeToFit();
        btn.addTarget(self, action: #selector(composeBtnAction), for: .touchUpInside);
        return  btn;
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupUI();
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        setupTabbarItem();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
//        do{
            //异常捕获位置
//        }catch{
//            出现异常时候执行的代码
//        }
    }
    //方法私有了 并且能回事件调用
    @objc private func composeBtnAction(){
        NSLog("composeBtnAction  ....");
        
//        let composeVC = ComposeVC()
//
//        let composeNav = UINavigationController(rootViewController: composeVC)
        
//        present(composeNav, animated: true, completion: nil);
        
    
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
extension MainViewController{
    private func steupUI(){
        //1.获取json文件路劲
        guard let  jsonUrl = Bundle.main.url(forResource: "MainVCSettings.json", withExtension: nil) else{
            NSLog("没有找到资源文件的路劲");
            return ;
        }
        //2.获取json中内容
        guard let jsonData = try?Data(contentsOf:jsonUrl) else{
            NSLog("没有获取到json中的数据")
            return ;
        }
        //3.解析出来转换成数组
        guard let anyObject = try?JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return;
        }
        //4.遍历字典,获取对应的信息
        guard let dictArray = anyObject as?[[String:AnyObject]] else {
            return;
        }
        //        for dict in dictArray{
        //            guard let vcName = dict["vcName"] as? String  else{
        //                continue;
        //            }
        //            guard let title = dict["title"] as? String else{
        //                continue;
        //            }
        //
        //            guard let imageName = dict["imageName"] as? String else{
        //                continue
        //            }
        //            addChildVC(vcName: vcName, title: title, imageName: imageName)
        //        }
        for i in 0..<dictArray.count{
            if i == 2{
                let vc = UIViewController();
                let navVC = UINavigationController(rootViewController: vc);
                addChild(navVC);
            }
            
            let dict = dictArray[i]
            guard let vcName = dict["vcName"] as? String  else{
                continue;
            }
            guard let title = dict["title"] as? String else{
                continue;
            }
            
            guard let imageName = dict["imageName"] as? String else{
                continue
            }
            addChildVC(vcName: vcName, title: title, imageName: imageName)
        }
        
        tabBar.addSubview(composeBtn);
        
        
        //viewDidLoad中调整好了 如果系统需要会在willAppler中调整计算 不应该这里设置
    }
    
    private func  setupTabbarItem(){
        let item = tabBar.items![2]
        item.isEnabled = false;
        if UIScreen.main.bounds.size.width>=375&&UIScreen.main.bounds.size.height>=812{
            composeBtn.center =  CGPoint(x: tabBar.center.x, y: (tabBar.bounds.size.height/2.0-15));
        }else{
            composeBtn.center =  CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height/2.0);
            
        }
    }
    
    private func addChildVC(vcName:String,title:String,imageName:String){
        //1获取命名空间 项目名字
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else{
            NSLog("没有获取命名空间")
            return;
        }
        guard let childVCClass = NSClassFromString(nameSpace+"."+vcName) else {
            NSLog("没有获取指定字符串的class");
            return
        }
        guard let childVCType = childVCClass as? UIViewController.Type else{
            NSLog("没有获取对应控制器的类型")
            return
        }
        //2 将对应的类对象 创建为对象
        let  childVC = childVCType.init();
        //3.0 设置子控制器的属性
        childVC.title = title ;
//        childVC.view.backgroundColor = UIColor.white;
        childVC.tabBarItem.image = UIImage(named: imageName);
        childVC.tabBarItem.selectedImage = UIImage(named: imageName+"_highlighted");
        //4.0用导航栏包装
        let  childNav = UINavigationController(rootViewController: childVC);
        //5.0添加控制器
        addChild(childNav);
        
        
    }
}
