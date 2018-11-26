//
//  Emoticon.swift
//  wk微博
//
//  Created by wangkang on 2018/5/1.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
@objcMembers
class Emoticon: NSObject {
    var code : String?{
        didSet{
            guard let code = code else {
                return
            }
            //创建扫描器
            let scanner = Scanner(string:code)
            //扫描code中的值
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            //将值转换成字符
//            let c  = Character(UnicodeScalar: value)
            let c = Unicode.Scalar(value)
            //将字符转成字符串
            emojiCode = String(c!)
            
        }
    }
    var png:String?{
        didSet{
            guard let png = png  else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    
    var chs : String?
    //数据处理
    var pngPath : String?
    var emojiCode : String?
    var isRemove:Bool = false
    var isEmpty : Bool = false
    init(dict:[String:String]){
        super.init()
        setValuesForKeys(dict)
    }
    init(isRemove: Bool ) {
        super.init()
        self.isRemove = isRemove
    }
    init(isEmpty:Bool){
        super.init()
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode","pngPath","chs"]).description
    }
}
