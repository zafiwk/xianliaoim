//
//  WSChatVoiceTableViewCell.h
//  QQ
//
//  Created by weida on 15/9/22.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import "WSChatBaseTableViewCell.h"


@protocol WSChatVoiceTableViewCellDelegate <NSObject>
-(void)reloadVoiceModel:(WSChatModel*)model;
@end
@interface WSChatVoiceTableViewCell : WSChatBaseTableViewCell

@property(nonatomic,weak)id<WSChatVoiceTableViewCellDelegate> delegate;
@end
