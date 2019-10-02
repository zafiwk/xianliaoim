//
//  Person.swift
//  wk微博
//
//  Created by wangkang on 2018/4/14.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class UserAccount: NSObject ,NSCoding{
    

    
    //授权的accessToken
    var  access_token : String?
    //过期时间 秒
    var  expires_in   : TimeInterval =  0.0{
        didSet{
            expires_date = Date(timeIntervalSinceNow: expires_in);
        }
    }
    //用户 Id
    var  uid : String?
    
    
    //设置过期时间
    var expires_date:Date?
    
    var screen_name :String?
    var avatar_large :String?
    var isRealName  : Bool?
    
//    init(dict : [String:AnyObject]){
//        super.init();
//        setValuesForKeys(dict)
//       
//    }
    //Mark:重写description属性
//    override var description: String{
//        return dictionaryWithValues(forKeys: ["access_token","expires_in","uid","expires_date","screen_name","avatar_large","isRealName"]).description;
//    }
    
    override init() {
        super.init()
    }

    
    //防止没有找到key报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        NSLog("没有找到key:|\(key)|  value:\(String(describing: value))");
    }
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
    /// 归档方法
    func  encode(with aCoder: NSCoder)  {
        
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
}
