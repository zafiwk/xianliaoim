//
//  StatusViewModel.swift
//  wk微博
//
//  Created by wangkang on 2018/4/18.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    
    var status : Status?
    
    //MARK:对数据处理的属性
    var sourceText : String? //处理来源
    var createAtText : String? //处理创建时间
    var verifiedImage : UIImage? //处理用户认证图标
    var vipImage : UIImage?     //处理用户会员等级
    var profileUrl: URL?        //处理用户头像的地址
    var picURLs : [URL] = [URL]()
    
    init(status:Status){
        self.status = status;
        //1.处理来源
        if let source = status.source, source != "" {
            let startIndex = (source as NSString).range(of: ">").location+1;
            let length = (source as NSString).range(of: "</").location - startIndex
            
            //截取字符串长度
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length));
        }
        // 2.处理时间
        if let createAt = status.created_at {
            createAtText = NSDate.createDateString(createAtStr: createAt)
        }
        
        //3.处理认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        //4.处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank>0 && mbrank <= 6{
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        //5. 用户头像的处理
        let profileURLString = status.user?.profile_image_url ?? ""
        profileUrl = URL(string: profileURLString)
        
        //6处理配图数据
        //转发时候
        let picURLDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        
        //非转发 bmiddle_pic中图片 thumbnail_pic微缩图
        if let picURLDicts = picURLDicts{
            for picURLDict in picURLDicts{
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue;
                }
//                let range = picURLString.range(of: "thumbnail");
//                picURLString.replaceSubrange(range!, with: "bmiddle");
                picURLs.append(URL(string: picURLString)!);
            }
        }
        //缓存一张图片时候 图片
//        if picURLs.count == 1 {
            //            imageView.kf.setImage(with: picURLs.first);
//            let  group =  DispatchGroup();
//            weak  var weakSelf:StatusViewModel! = self
//
//
//            //            for picURL   in viewModel.picURLs{
//            //                group.enter()
//            //            }
//
//            group.enter()
//            let  imageView = UIImageView();
//            imageView.kf.setImage(with: picURLs.fri, placeholder: nil, options: [], progressBlock: nil) { (_, _, _, _) in
//                group.leave()
//            }
//            group.notify(queue: DispatchQueue.main) {
//
//            }
            
//        }
    }
}


