//
//  WKPBindWeibo.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/8.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPBindWeibo.h"
#import "PublicHead.h"

@interface WKPBindWeibo ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *commit;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation WKPBindWeibo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.desLabel.text=@"账号和密码保存在本地,app删除后就会删除相关记录。绑定微博账号和密码后就能使用一键填写功能";
    self.view.backgroundColor= [UIColor whiteColor];
    [self.commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commit.backgroundColor=UIColorFromRGB(0xec7e3c);
    self.commit.layer.masksToBounds=YES;
    self.commit.layer.cornerRadius=5;
    
    self.userName.placeholder=@"用户名";
    self.passWord.placeholder=@"登入密码";
    [self.commit setTitle:@"确定绑定" forState:UIControlStateNormal];
    
    [self.commit addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
}


-(void)commitClick{
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userName.text forKey:@"WEIBON"];
    [userDefaults setObject:self.passWord.text forKey:@"WEIBOP"];
    [userDefaults synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
