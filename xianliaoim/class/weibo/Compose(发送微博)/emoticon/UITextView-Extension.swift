//
//  UITextView-Extension.swift
//  wk微博
//
//  Created by wangkang on 2018/5/2.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

extension UITextView {
    //转字符用于发送给服务器
    func getEmoticonString() ->String{
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (
            dict, range, _) in
            if let attachment = dict[NSAttributedString.Key(rawValue: "NSAttachment")] as? EmoticonAttachment{
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        return  attrMStr.string;
    }
 
    func insertEmoticon(emoticon:Emoticon){
        //1.空白
        if emoticon.isEmpty{
            return
        }
        //2.删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        //3.emoji表情
        if emoticon.emojiCode != nil{
            let textRange = selectedTextRange
            replace(textRange!, withText: emoticon.emojiCode!)
            return
        }
        //4图文混排
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        //获取光标的位置
        let range = selectedRange
        
        //替换属性字符串
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        
        //显示属性字符串
        attributedText = attrMStr
        
        // 防止字体变小
        self.font = font
        //移动光标
        selectedRange = NSRange(location: range.location+1, length: 0)
    }
}
