//
//  MBProgressHUD+WKPMBProgressHUDCategory.h
//  xianliaoim
//
//  Created by wangkang on 2018/11/30.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>


@interface MBProgressHUD (WKPMBProgressHUDCategory)
+(void)showSuccess:(NSString*)success toView:(UIView*)view;
+(void)showError:(NSString*)error toView:(UIView*)view;

+(MBProgressHUD*)showMessage:(NSString*)message toView:(UIView*)view;
@end


