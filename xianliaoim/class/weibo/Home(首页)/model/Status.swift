//
//  Status.swift
//  wk微博
//
//  Created by wangkang on 2018/4/16.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import HandyJSON
class Status: HandyJSON {

    //微博创建时间
    var created_at : String?
    //微博来源
    var source : String?
    //微博正文
    var text : String?
    //微博id
    var mid :Int = 0;
    //微博对应的用户
    var user : User?
    //配图
    var pic_urls:[[String : String]]?
    //微博对应的转发微博
    var retweeted_status : Status?
    
    required init() {}
    
    init(dict :[String:AnyObject]){
        
        if let userDict = dict["user"] as? [String:AnyObject]{
            user = User.deserialize(from: userDict);
        }
        
        
        if let retweetedStatusDict = dict["retweeted_status"]  as? [String : AnyObject]{
            retweeted_status = Status.deserialize(from: retweetedStatusDict);
        }
    }
    
}
