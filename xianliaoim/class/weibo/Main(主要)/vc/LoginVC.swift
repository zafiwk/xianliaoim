//
//  LoginVC.swift
//  wk微博
//
//  Created by wangkang on 2018/4/14.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
class LoginVC: UIViewController {

    private lazy var webView:WKWebView = {
        let webViewConf = WKWebViewConfiguration();
        let webView:WKWebView = WKWebView(frame: view.bounds, configuration: webViewConf);
        webView.uiDelegate = self;
        webView.navigationDelegate = self;
        return webView;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView);
//        webView.load(URLRequest(url: URL(string: "https://www.baidu.com")!));
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        guard let url = URL(string: urlString) else{
            return;
        }
        
        let request = URLRequest(url: url);
        
        webView.load(request);
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .done, target: self, action: #selector(exitst));
    navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "一键填写", style: .done, target: self, action: #selector(autoInput));
    navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: - action
extension LoginVC {
    @objc private func exitst(){
        dismiss(animated: true, completion: nil);
    }
    
    @objc private func autoInput(){
        let userDefaults = UserDefaults.standard;
 
        
        guard let username = userDefaults.object(forKey: "WEIBON") as? String else {
            SVProgressHUD.showError(withStatus: "没有绑定新浪微博账号")
            SVProgressHUD.dismiss(withDelay: 2.0)
            return
        }
        
        guard let password = userDefaults.object(forKey: "WEIBOP") as? String else{
            SVProgressHUD.showError(withStatus: "没有绑定新浪微博账号")
            SVProgressHUD.dismiss(withDelay: 2.0)
            return
        }
        let jsCode = "document.getElementById('userId').value='\(username)';document.getElementById('passwd').value='\(String(describing: password))';"
        webView.evaluateJavaScript(jsCode, completionHandler: nil);
    }
}
extension LoginVC : WKUIDelegate { 
    
}
extension LoginVC : WKNavigationDelegate {
    //页面加载完成之后调用
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        NSLog("web加载完成");
        SVProgressHUD.dismiss();
    }
    
    //页面加载失败时候
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        NSLog("页面加载失败失败")
        SVProgressHUD.dismiss();
    }
    
    //页面开始时加载时候调用
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("页面开始加载时候");
        SVProgressHUD.show();
    }

    
    //收到服务器返回的跳转请求
//    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        
//    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        let ulrString : String = (navigationResponse.response.url?.absoluteString)!
//        NSLog("urlString  :\(ulrString!)")
        guard ulrString.contains("code=") else {
            decisionHandler(.allow);
            return
        }
        
        var code = ulrString.components(separatedBy: "code=").last
        code = code?.components(separatedBy: "&").first
        NSLog("code :\(code!)")
        loadAccessToken(code: code!);
        decisionHandler(.cancel)
//        dismiss(animated: true, completion: nil);
        
        
    }
    
}

extension LoginVC{
    private func loadAccessToken(code:String){
        SVProgressHUD.showInfo(withStatus: "获取授权令牌中...")
        NetTools.shareInstance.loadAccessToken(code: code) { [unowned self](result, error) in
            NSLog("令牌信息\(String(describing: result))")
            SVProgressHUD.dismiss();
            if error != nil {
                NSLog("\(String(describing: error))");
                return
            }
            guard let accountDict = result else{
                NSLog("没有获取到授权后的数据")
                return;
            }
            let  account = UserAccount();
            account.isRealName = accountDict["isRealName"] as? Bool
            account.uid = accountDict["uid"] as? String
            account.access_token = accountDict["access_token"] as? String
            account.expires_in = (accountDict["expires_in"] as? TimeInterval)!
            
            self.loadUserInfo(account: account);
        }
    }
    
    private func loadUserInfo(account : UserAccount){
        guard let accessToken = account.access_token else{
            return ;
        }
        guard let uid = account.uid else{
            return;
        }
        SVProgressHUD.showInfo(withStatus: "查询个人信息中...")
        NetTools.shareInstance.loadUserInfo(access_token: accessToken, uid: uid) {[unowned self] (result, error) in
            SVProgressHUD.dismiss();
            NSLog("个人信息:\(String(describing: result))");
            if error != nil {
                NSLog("\(String(describing: error))")
            }
            //2拿到用户的信息结果
            guard let userInfoDict = result else{
                return
            }
            
            // 3.从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            print(account)
//            self.dismiss(animated: true, completion: nil);
            
            //4.归档对象
            NSLog("归档路劲:\(UserAccountViewModel.shareIntance.accountPath)")
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewModel.shareIntance.accountPath);
            
            //5.对象设置中控制器视图中
            UserAccountViewModel.shareIntance.account = account
            
            //6切换主控制器
//            UIApplication.shared..rootViewController = MainViewController();
            self.dismiss(animated: true, completion: {
                
//                UIApplication.shared.keyWindow?.rootViewController=WelcomeVC();
//                let vc = WelcomeVC();
//                navigationController?.pushViewController(vc, animated: true);
            });
        }
        
    }
}
