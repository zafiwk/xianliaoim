//
//  WSChatMessageInputBar.h
//  QQ
//
//  Created by weida on 15/9/23.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import <UIKit/UIKit.h>
#import "IMTools.h"
@protocol WSChatMessageInputBarDelegate <NSObject>

@optional
-(void)voiceSavePath:(NSString*)path;

-(void)startRecord;

-(void)canelRecord;
@end

/**
 *  @brief  聊天界面底部输入界面
 */
@interface WSChatMessageInputBar : UIView
@property(nonatomic,weak) id<WSChatMessageInputBarDelegate> delegate;
@property(nonatomic,strong)EMConversation* con;
@end
