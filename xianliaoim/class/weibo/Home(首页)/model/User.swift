//
//  User.swift
//  wk微博
//
//  Created by wangkang on 2018/4/16.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import HandyJSON
class User: HandyJSON {
    var profile_image_url:String? //用户的头像
    var screen_name : String?     //用户的昵称
    var verified_type : Int = -1  //用户认证类型
    var mbrank : Int = 0          //用户会员等级
    required init() {}
}
