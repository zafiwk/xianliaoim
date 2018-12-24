//
//  AppDelegate.h
//  xianliaoim
//
//  Created by wangkang on 2018/11/26.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EM1v1CallViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,weak)EM1v1CallViewController* callVC;
@end

