//
//  WKPChangNickVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/7.
//  Copyright © 2018 wangkang. All rights reserved.
//
#import "PublicHead.h"
#import "WKPChangNickVC.h"
#import <Hyphenate/Hyphenate.h>
@interface WKPChangNickVC ()

@end

@implementation WKPChangNickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmBtn.backgroundColor = UIColorFromRGB(0xec7e3c);
    self.confirmBtn.layer.masksToBounds=YES;
    self.confirmBtn.layer.cornerRadius=5;
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)confirmBtnClick{
//    NSString* nickName= self.input.text;
//    if (nickName.length>6||nickName.length==0) {
//        [MBProgressHUD showError:@"昵称长度不大于6个字符" toView:self.view];
//        return;
//    }
//    __weak  typeof(self) weakSelf=self;
//    MBProgressHUD* hud=[MBProgressHUD showMessage:@"请求发送中" toView:nil];
//    UserProfileManager* manager=[UserProfileManager sharedInstance];
//    [manager updateUserProfileInBackground:@{kPARSE_HXUSER_NICKNAME:nickName} completion:^(BOOL success, NSError *error) {
//\
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES];
//            if (error) {
//                NSLog(@"%@",error);
//                [MBProgressHUD showError:@"出错了,请稍后再试" toView:weakSelf.view];
//            }else{
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//            }
//        });
//        
//        EMClient* client=[EMClient sharedClient];
//        [manager loadUserProfileInBackground:@[[client currentUsername]] saveToLoacal:YES completion:^(BOOL success, NSError *error) {
//            
//        }];
//    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
