//
//  MBProgressHUD+WKPMBProgressHUDCategory.m
//  xianliaoim
//
//  Created by wangkang on 2018/11/30.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "MBProgressHUD+WKPMBProgressHUDCategory.h"

@implementation MBProgressHUD (WKPMBProgressHUDCategory)
+(MBProgressHUD*)showMessage:(NSString*)message toView:(UIView*)view{
    if (!view) {
        view=[[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text=message;
    hud.removeFromSuperViewOnHide=YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    return hud;
}
+(void)showSuccess:(NSString*)success toView:(UIView*)view{
    [self show:success icon:@"success" view:view];
}
+(void)showError:(NSString*)error toView:(UIView*)view{
    [self show:error icon:@"error" view:view];
}
+(void)show:(NSString*)text icon:(NSString*)icon view:(UIView*)view{
    if (!view) {
        view=[[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text=text;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:icon]];
    hud.mode =MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide=YES;
    [hud hideAnimated:YES afterDelay:1.5];
}
@end
