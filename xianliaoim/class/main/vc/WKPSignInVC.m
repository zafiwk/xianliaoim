//
//  WKPSignInVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/5.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPSignInVC.h"
#import "PublicHead.h"
#import "WKPSignUpVC.h"
#import <Masonry/Masonry.h>

#import "UserProfileManager.h"
@interface WKPSignInVC ()
@property (weak, nonatomic) IBOutlet UITextField *telName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property(nonatomic,strong) UIButton* signUpBtn;
@property(nonatomic,strong) UIButton* changePasswordBtn;


@end

@implementation WKPSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.telName.placeholder  =@"请输入注册的手机号码";
    
    self.password.placeholder = @"请输入登入密码";
    
    self.title=@"登入";
    [self.loginBtn setTitle:@"登入" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.backgroundColor=UIColorFromRGB(0xec7e3c);
    [self.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.signUpBtn = [[UIButton alloc]init];
    self.signUpBtn.titleLabel.font =[UIFont systemFontOfSize:12];
    [self.signUpBtn setTitle:@"没有账号?立即注册" forState:UIControlStateNormal];
    [self.signUpBtn setTitleColor:UIColorFromRGB(0xec7e3c) forState:UIControlStateNormal];
    [self.signUpBtn sizeToFit];
    [self.view addSubview:self.signUpBtn];
    __weak typeof(self) weakSelf= self;
    [self.signUpBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-40);
        make.top.mas_equalTo(weakSelf.loginBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(weakSelf.signUpBtn.frame.size.width);
        make.height.mas_equalTo(weakSelf.signUpBtn.frame.size.height);
    }];
    [self.signUpBtn addTarget:self action:@selector(signUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    环信不支持修改密码
    self.changePasswordBtn = [[UIButton alloc]init];
    self.changePasswordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.changePasswordBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.changePasswordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.changePasswordBtn sizeToFit];
    [self.view addSubview:self.changePasswordBtn];
    [self.changePasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(weakSelf.loginBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(weakSelf.changePasswordBtn.frame.size.width);
        make.height.mas_equalTo(weakSelf.changePasswordBtn.frame.size.height);
    }];
    [self.changePasswordBtn addTarget:self action:@selector(cpbBtnClick) forControlEvents:UIControlEventTouchUpInside];
    */
}

-(void)signUpBtnClick{
    WKPSignUpVC* vc=[[WKPSignUpVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)cpbBtnClick{
    WKPSignUpVC* vc=[[WKPSignUpVC alloc]init];
    vc.type=RETRIEVEPASSWORD;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loginBtnClick{
    MBProgressHUD* hud=[MBProgressHUD showMessage:@"登入中" toView:nil];
    NSString*  loginName = [NSString stringWithFormat:@"WKP%@",self.telName.text];
    
    __weak  typeof(self) weakSelf = self;
  
    
}
@end
