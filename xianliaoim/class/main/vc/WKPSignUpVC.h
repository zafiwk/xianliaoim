//
//  WKPSignUpVC.h
//  xianliaoim
//
//  Created by wangkang on 2018/11/30.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,WKPSignUpVCType) {
    REGISTERED     = 0,   //注册
    RETRIEVEPASSWORD     //修改密码
};
@interface WKPSignUpVC : UIViewController
@property(nonatomic,assign)WKPSignUpVCType type;
@end

NS_ASSUME_NONNULL_END
