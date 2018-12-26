//
//  PublicHead.h
//  xianliaoim
//
//  Created by wangkang on 2018/11/30.
//  Copyright © 2018 wangkang. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define kRGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:1.f]

#define BtnBgColor UIColorFromRGB(0xec7e3c)


#define  UIWidth  [UIScreen mainScreen].bounds.size.width
#define  UIHeight [UIScreen mainScreen].bounds.size.height
#import "xianliaoim-Bridging-Header.h"
#import "xianliaoim-Swift.h"
#import "MBProgressHUD+WKPMBProgressHUDCategory.h"

//通过DEBUG宏的定义来解决Debug状态下和Release状态下的输出
#ifdef DEBUG
#define WKPLog(...) NSLog(__VA_ARGS__)
#else
#define WKPLog(...)
#endif /* PrefixHeader_pch */


#define iconPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"icon"]
#define DEMO_CALL  1
