//
//  UserAccountViewModel.swift
//  wk微博
//
//  Created by wangkang on 2018/4/15.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class UserAccountViewModel: NSObject {
    static let shareIntance:UserAccountViewModel = UserAccountViewModel()
    var account:UserAccount?
    var accountPath : String  = {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        NSLog("accountPath:\(accountPath)")
        return (accountPath as NSString).appendingPathComponent("account.plist")
    }();
    
    var isLogin:Bool {
        if account == nil {
            return false;
        }
        guard let expiresDate = account?.expires_date else {
            return false
        }
        return expiresDate.compare(Date()) ==  ComparisonResult.orderedDescending

    }
    // MARK:- 重写init()函数
    override init () {
        // 1.从沙盒中读取中归档的信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}
