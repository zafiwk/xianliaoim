//
//  RequestModel.h
//  xianliaoim
//
//  Created by wangkang on 2018/11/27.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestModel : NSObject
@property(nonatomic,assign)NSInteger keyId;
@property(nonatomic,strong)NSString* message;
@property(nonatomic,strong)NSString* username;
@end

NS_ASSUME_NONNULL_END
