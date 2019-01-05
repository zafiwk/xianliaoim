//
//  WKPRemark.h
//  xianliaoim
//
//  Created by wangkang on 2018/12/29.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemarkModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WKPRemark : UIViewController
@property(nonatomic,strong)RemarkModel* remark;
@property(nonatomic,strong)NSString* userName;
@end

NS_ASSUME_NONNULL_END
