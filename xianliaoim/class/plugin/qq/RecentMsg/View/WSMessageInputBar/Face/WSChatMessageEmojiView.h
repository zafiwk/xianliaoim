//
//  WSChatMessageFaceView.h
//  QQ
//
//  Created by weida on 15/9/24.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import <UIKit/UIKit.h>

/**
 *  @brief  表情视图
 */

@protocol emojiViewSelectDelegate <NSObject>
-(void)emojiSelectModel:(NSDictionary *)model;
-(void)sendText;
@end
@interface WSChatMessageEmojiView : UIView
@property(nonatomic,strong)id<emojiViewSelectDelegate> delegate;
@end
