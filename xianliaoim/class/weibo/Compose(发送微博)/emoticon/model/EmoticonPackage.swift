//
//  EmoticonPackage.swift
//  wk微博
//
//  Created by wangkang on 2018/5/1.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    var emoticons : [Emoticon] = [Emoticon]()
    init(id:String){
        super.init()
        if id == ""{
            addEmptyEmoticon(isRecently: true)
            return
        }
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        
        let array = NSArray(contentsOfFile: plistPath!) as! [[String:String]]
        var index = 0
        for var  dict in array{
            if let png = dict["png"]{
                dict["png"] =  id + "/" + png
            }
            
            emoticons.append(Emoticon(dict: dict))
            index += 1
            
            if index == 20 {
                emoticons.append(Emoticon(isRemove: true))
                index = 0
            }
        }
        
        addEmptyEmoticon(isRecently: false);
    }
    private func addEmptyEmoticon(isRecently:Bool){
        let count = emoticons.count%21
        if count == 0 && !isRecently{
            return
        }
        
        for _ in count..<20{
            emoticons.append(Emoticon(isEmpty: true))
        }
        emoticons.append(Emoticon(isRemove: true))
    }
}
