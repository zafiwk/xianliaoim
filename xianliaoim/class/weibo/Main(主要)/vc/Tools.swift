//
//  Tools.swift
//  wk微博
//
//  Created by wangkang on 2018/4/14.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

let  app_key = "1094101296"
let  app_secret       = "b9e2503df51c2a26668374aea28a6ab5"
let  redirect_uri = "http://www.baidu.com"

let UIFrame  = UIScreen.main.bounds
let UIWidth  = UIFrame.size.width
let UIHeight = UIFrame.size.height


// MARK:- 选择照片的通知常量
let PicPickerAddPhotoNote = "PicPickerAddPhotoNote"
let PicPickerRemovePhotoNote = "PicPickerRemovePhotoNote"
let ShowPhotoBrowserNote     = "ShowPhotoBrowserNote"
let ShowPhotoBrowserIndexKey = "ShowPhotoBrowserIndexKey"
let ShowPhotoBrowserUrlsKey  = "ShowPhotoBrowserUrlsKey"
extension UIView{
    func getX() -> CGFloat {
        return self.frame.origin.x;
    }
    func setX(x:CGFloat){
        self.frame = CGRect(x: x, y: getY(), width:getWidth(), height: getHeight());
    }
    
    func getY() -> CGFloat{
        return self.frame.origin.y;
    }
    func setY(y:CGFloat) {
        self.frame = CGRect(x: self.frame.origin.x, y: y, width:getWidth(), height: getHeight())
    }
    
    func  getWidth()->CGFloat{
        return self.bounds.width;
    }
    
    func setWidth(width:CGFloat) {
        self.frame = CGRect(x: self.getX(), y: self.getY(), width: width, height: self.getHeight())
    }
    
    
    func getHeight() -> CGFloat {
        return self.bounds.size.height;
    }
    func setHeight(height:CGFloat) {
        self.frame=CGRect(x: getX(), y: getY(), width: getWidth(), height: height);
    }
}

extension UIColor {
    // 16进制 转 RGBA
    class func rgbaColorFromHex(rgb:Int, alpha: CGFloat) ->UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    
    //16进制 转 RGB
    class func rgbColorFromHex(rgb:Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
}

