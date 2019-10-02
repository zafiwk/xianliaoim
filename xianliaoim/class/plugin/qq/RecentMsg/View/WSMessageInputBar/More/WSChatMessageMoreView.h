//
//  WSChatMessageMoreView.h
//  QQ
//
//  Created by weida on 15/9/24.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import <UIKit/UIKit.h>
#import "IMTools.h"
#define moreBtnClickNoti   @"moreBtnClick"
/**
 *  @brief  更多、图片、段视频、文件等
 */
@interface WSChatMessageMoreView : UIView
@property(nonatomic,strong)EMConversation* con;
@end
