//
//  WSChatMessageInputBar.h
//  QQ
//
//  Created by weida on 15/9/23.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import <UIKit/UIKit.h>

@protocol WSChatMessageInputBarDelegate <NSObject>
-(void)voiceSavePath:(NSString*)path;
@end

/**
 *  @brief  聊天界面底部输入界面
 */
@interface WSChatMessageInputBar : UIView
@property(nonatomic,weak) id<WSChatMessageInputBarDelegate> delegate;
@end
