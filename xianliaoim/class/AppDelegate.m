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
#import <Hyphenate/Hyphenate.h>
#import "IMTools.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpUI];
    [self setUpIM:launchOptions];
    [self setUPParse:launchOptions];
    return YES;
}

-(void)setUpIM:(NSDictionary*)launchOptions{
//    EMOptions* options= [EMOptions optionsWithAppkey:@"wkdlose#com-wangkang-xianliaoim"];
//    options.apnsCertName=@"istore_dev";
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
    IMTools* tools=[IMTools defaultInstance];
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

    
    FWNavigationController* messageNaviC=[[FWNavigationController alloc]initWithRootViewController:[[UIViewController alloc]init]];
    messageNaviC.title=@"消息";
    [tabBarVC addChildViewController:messageNaviC];
    messageNaviC.tabBarItem.image = [UIImage imageNamed:@"tab_recent_nor"];
    messageNaviC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_recent_press"];
   
    
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDWebImageManager sharedManager] cancelAll];
}

@end
