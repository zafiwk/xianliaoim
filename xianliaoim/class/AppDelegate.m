//
//  AppDelegate.m
//  xianliaoim
//
//  Created by wangkang on 2018/11/26.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "AppDelegate.h"
#import "WKPSignUpVC.h"
#import "PublicHead.h"
#import "ContactHomeVC.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import <Parse/Parse.h>
#import "FWNavigationController.h"
#import "WKPMeVC.h"
#import "IMTools.h"
#import "WKPMessageVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpUI];
    [self setUpIM:launchOptions];
//    [self setUPParse:launchOptions];
    
    WKPLog(@"===========用户的个人文件地址=============");
    WKPLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]);
    WKPLog(@"========================================");
    return YES;
}

-(void)setUpIM:(NSDictionary*)launchOptions{
    IMTools* tools = [IMTools defaultInstance];
    [tools setUpIM:launchOptions];
}

-(void)setUPParse:(NSDictionary*)launchOptions{
    [Parse enableLocalDatastore];
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration>  _Nonnull configuration) {
        configuration.applicationId = @"UUL8TxlHwKj7ZXEUr2brF3ydOxirCXdIj9LscvJs";
        configuration.clientKey = @"B1jH9bmxuYyTcpoFfpeVslhmLYsytWTxqYqKQhBJ";
        configuration.server = @"http://parse.easemob.com/parse/";
    }]];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    PFACL* defaultACL=[PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}
-(void)setUpUI{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
    UITabBarController* tabBarVC=[[UITabBarController alloc]init];

    WKPMessageVC* messagevc=[[WKPMessageVC alloc]initWithStyle:UITableViewStylePlain];
    FWNavigationController* messageNaviC=[[FWNavigationController alloc]initWithRootViewController:messagevc];
    messagevc.title=@"消息";
    messagevc.tabBarItem.image = [UIImage imageNamed:@"tab_recent_nor"];
    messagevc.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_recent_press"];
    [tabBarVC addChildViewController:messageNaviC];
    
    
    ContactHomeVC* contactVC= [[ContactHomeVC alloc]initWithStyle:UITableViewStylePlain];
    contactVC.title =@"好友";
    FWNavigationController* contactNaviC=[[FWNavigationController alloc]initWithRootViewController:contactVC];
    [tabBarVC addChildViewController:contactNaviC];
    contactNaviC.tabBarItem.image =[UIImage imageNamed:@"tab_buddy_nor"];
    contactNaviC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_buddy_press"];
    

    HomeViewController* homeVC= [[HomeViewController alloc]init];
    FWNavigationController* seeNaviC=[[FWNavigationController alloc]initWithRootViewController:homeVC];
    [tabBarVC addChildViewController:seeNaviC];
    seeNaviC.tabBarItem.image = [UIImage imageNamed:@"tab_see_nor"];
    seeNaviC.tabBarItem.selectedImage=[UIImage imageNamed:@"tab_see_press"];
    homeVC.title=@"发现";

    
    WKPMeVC* meVC=[[WKPMeVC alloc]initWithStyle:UITableViewStyleGrouped];
    FWNavigationController* mineNaviC=[[FWNavigationController alloc]initWithRootViewController:meVC];
    [tabBarVC addChildViewController:mineNaviC];
    mineNaviC.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
    mineNaviC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_profile_highlighted"];
    meVC.title=@"我";

    self.window.rootViewController=tabBarVC;
//    WKPLoginVC* loginVC=[[WKPLoginVC alloc]init];
//    UINavigationController* loginC=[[UINavigationController alloc]initWithRootViewController:loginVC];
//    self.window.rootViewController=loginC;
    [self.window makeKeyAndVisible];
}
// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDWebImageManager sharedManager] cancelAll];
}

@end
