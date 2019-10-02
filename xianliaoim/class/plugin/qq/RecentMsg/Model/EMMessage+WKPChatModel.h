//
//  EMMessage+WKPChatModel.h
//  xianliaoim
//
//  Created by wangkang on 2018/12/20.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <Hyphenate/Hyphenate.h>
#import "WSChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EMMessage (WKPChatModel)
-(WSChatModel*)model;
-(NSString*)dateStr;
@end

NS_ASSUME_NONNULL_END
