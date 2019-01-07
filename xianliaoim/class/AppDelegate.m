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
#import "Call1v1AudioViewController.h"
#import "Call1v1VideoViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UITabBarControllerDelegate>
@property(nonatomic,strong) FWNavigationController* navigationVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpUI];
    [self setUpIM:launchOptions];
//    [self setUPParse:launchOptions];
    
    WKPLog(@"===========用户的个人文件地址=============");
    WKPLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]);
    WKPLog(@"========================================");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callNotification:) name:MessageCallVC object:nil];
    //注册通知
//    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//
//    }];
//    UNNotificationCategory* generalCategory = [UNNotificationCategory categoryWithIdentifier:@"GENERAL" actions:@[] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
//
//    // Create the custom actions for expired timer notifications.
//    UNNotificationAction* snoozeAction = [UNNotificationAction actionWithIdentifier:@"SNOOZE_ACTION"  title:@"Snooze" options:UNNotificationActionOptionAuthenticationRequired];
//    UNNotificationAction* stopAction = [UNNotificationAction actionWithIdentifier:@"STOP_ACTION"  title:@"Stop" options:UNNotificationActionOptionDestructive];
//    UNNotificationAction* forAction = [UNNotificationAction actionWithIdentifier:@"FOR_ACTION"  title:@"forAction" options:UNNotificationActionOptionForeground];
//    // Create the category with the custom actions.
//    UNNotificationCategory* expiredCategory = [UNNotificationCategory categoryWithIdentifier:@"TIMER_EXPIRED" actions:@[snoozeAction, stopAction,forAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
//    // Register the notification categories.
//    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
//    [center setDelegate:self];
//    [center setNotificationCategories:[NSSet setWithObjects:generalCategory, expiredCategory,
//                                       nil]];
//
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            WKPLog(@"授权成功");
        } else {
            WKPLog(@"授权失败，引导用户前往设置");
        }
    }];
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
    tabBarVC.delegate = self;
    WKPMessageVC* messagevc=[[WKPMessageVC alloc]initWithStyle:UITableViewStylePlain];
    FWNavigationController* messageNaviC=[[FWNavigationController alloc]initWithRootViewController:messagevc];
    messagevc.title=NSLocalizedString(@"消息", nil);
    messagevc.tabBarItem.image = [UIImage imageNamed:@"tab_recent_nor"];
    messagevc.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_recent_press"];
    [tabBarVC addChildViewController:messageNaviC];
    self.navigationVC = messageNaviC;
    
    ContactHomeVC* contactVC= [[ContactHomeVC alloc]initWithStyle:UITableViewStylePlain];
    contactVC.title =NSLocalizedString(@"好友", nil);
    FWNavigationController* contactNaviC=[[FWNavigationController alloc]initWithRootViewController:contactVC];
    [tabBarVC addChildViewController:contactNaviC];
    contactNaviC.tabBarItem.image =[UIImage imageNamed:@"tab_buddy_nor"];
    contactNaviC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_buddy_press"];
    

    HomeViewController* homeVC= [[HomeViewController alloc]init];
    FWNavigationController* seeNaviC=[[FWNavigationController alloc]initWithRootViewController:homeVC];
    [tabBarVC addChildViewController:seeNaviC];
    seeNaviC.tabBarItem.image = [UIImage imageNamed:@"tab_see_nor"];
    seeNaviC.tabBarItem.selectedImage=[UIImage imageNamed:@"tab_see_press"];
    homeVC.title=NSLocalizedString(@"发现", nil);

    
    WKPMeVC* meVC=[[WKPMeVC alloc]initWithStyle:UITableViewStyleGrouped];
    FWNavigationController* mineNaviC=[[FWNavigationController alloc]initWithRootViewController:meVC];
    [tabBarVC addChildViewController:mineNaviC];
    mineNaviC.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
    mineNaviC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_profile_highlighted"];
    meVC.title =  NSLocalizedString(@"我", nil);

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
#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[FWNavigationController class]]) {
        self.navigationVC=(FWNavigationController*)viewController;
    }
}

-(void)callNotification:(NSNotification*)noti{
    if (self.callVC) {
        return;
    }
    
    NSDictionary* userInfo =noti.userInfo;
    EMCallSession* aSession=userInfo[MessageCallSession];
    if (aSession.type== EMCallTypeVoice) {
        Call1v1AudioViewController* callvc=[[Call1v1AudioViewController alloc]initWithCallSession:aSession];
        UIViewController* vc= self.navigationVC.topViewController;
        self.callVC =callvc;
        [vc presentViewController:callvc animated:YES completion:^{
        
        }];
    }else{
        Call1v1VideoViewController* callvc=[[Call1v1VideoViewController alloc]initWithCallSession:aSession];
        UIViewController* vc= self.navigationVC.topViewController;
        self.callVC =callvc;
        [vc presentViewController:callvc animated:YES completion:^{
            
        }];
    }

}


@end
