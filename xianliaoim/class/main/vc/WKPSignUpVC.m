//
//  WKPSignUpVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/11/30.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPSignUpVC.h"
#import "PublicHead.h"
#import <SMS_SDK/SMSSDK.h>
#import <Hyphenate/Hyphenate.h>
#import <Masonry/Masonry.h>
#import "UIImage+WKPImageTool.h"
#import "WKPWebVC.h"
@interface WKPSignUpVC ()
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *cmRequestBtn;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property(nonatomic,assign)NSInteger s;
@property(nonatomic,strong)NSTimer* sTimer;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;


@end

@implementation WKPSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signInBtn.backgroundColor=UIColorFromRGB(0xec7e3c);
    [self.cmRequestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cmRequestBtn.backgroundColor=UIColorFromRGB(0xec7e3c);
    
    self.cmRequestBtn.layer.masksToBounds=YES;
    self.cmRequestBtn.layer.cornerRadius=5;
    
    self.signInBtn.layer.masksToBounds=YES;
    self.signInBtn.layer.cornerRadius=5;
    
    self.telTextField.placeholder = @"请输入注册的手机号码";
    self.passWordTextField.placeholder = @"请输入密码";
    self.yanzhengmaTextField.placeholder=@"请输入手机验证码";
    [self.cmRequestBtn setTitle:@"短信校验" forState:UIControlStateNormal];
    if (self.type==REGISTERED) {
        [self.signInBtn setTitle:@"注册" forState:UIControlStateNormal];
        self.title=@"用户注册";
    }else{
        [self.signInBtn setTitle:@"密码修改" forState:UIControlStateNormal];
        self.title=@"密码修改";
    }
    
    [self.signInBtn addTarget:self action:@selector(siginInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cmRequestBtn addTarget:self action:@selector(cmRequestBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.agreeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    self.protocolBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    self.agreeBtn.selected = YES;
    [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [self.agreeBtn setImage:[UIImage imageNamed:@"success"] forState:UIControlStateNormal];
    [self.agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* image=[UIImage imageNamed:@"success-1"];
    
    [self.agreeBtn setImage:image forState:UIControlStateSelected];

    __weak  typeof(self) weakSelf = self;
    CGFloat x=[self.view getWidth]/2.0-90;
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(x);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(-30);
    }];
    
    
    [self.protocolBtn setTitle:@"《闲聊app用户使用协议》" forState:UIControlStateNormal];
    [self.protocolBtn sizeToFit];
    [self.protocolBtn setTitleColor:UIColorFromRGB(0xec7e3c) forState:UIControlStateNormal];
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.agreeBtn.mas_top);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(weakSelf.agreeBtn.mas_right).offset(-2);
        make.width.mas_equalTo([weakSelf.protocolBtn getWidth]);
    }];
    
    [self.protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark  btnClick
-(void)siginInBtnClick{
    if (![self checkTel]) {
        return;
    }
    if (self.passWordTextField.text.length<8||self.passWordTextField.text.length>12) {
        [MBProgressHUD showError:@"密码应该有数字字母组成,长度不小于8位不大于12位" toView:self.view];
        return;
    }
//    [[EMClient sharedClient] registerWithUsername:self.telTextField.text password:self.passWordTextField.text];
    
    if (self.type ==REGISTERED) {
        __weak  typeof(self) weakSelf = self;
        [SMSSDK commitVerificationCode:self.yanzhengmaTextField.text phoneNumber:self.telTextField.text zone:@"86" result:^(NSError *error) {
            if (error) {
                [MBProgressHUD showError:error.localizedDescription toView: weakSelf.view];
                return ;
            }else{
                NSString* loginName = [NSString stringWithFormat:@"wkp%@",weakSelf.telTextField.text];
                MBProgressHUD* hud=[MBProgressHUD showMessage:@"注册中...." toView:nil];
                [[EMClient sharedClient] registerWithUsername:loginName password:weakSelf.passWordTextField.text completion:^(NSString *aUsername, EMError *aError) {
                    [hud hideAnimated:YES];
                    if (aError) {
                        [MBProgressHUD showError:aError.errorDescription toView:weakSelf.view];
                    }else{
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }
        }];
    }else{
        
    }
  
}

-(void)cmRequestBtnClick{

    if (![self checkTel]) {
        return;
    }
    
    if (self.s!=0) {
        return;
    }
    self.s=60;
//    带自定义模版
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.telTextField.text zone:@"86"  result:^(NSError *error) {
        if (error){
            [MBProgressHUD showSuccess:@"未知错误稍后再试" toView:self.view];
        }else{
            [MBProgressHUD showSuccess:@"消息发送成功,短信可能存在延迟" toView:self.view];
        }
    }];
    self.sTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.s--;
        if (self.s==0) {
            [self.sTimer invalidate];
            self.sTimer = nil;
            [self.cmRequestBtn setTitle:@"短信校" forState:UIControlStateNormal];
        }else{
            [self.cmRequestBtn setTitle:[NSString stringWithFormat:@"短信校验(%ld)",self.s] forState:UIControlStateNormal];
        }
    }];
}

-(BOOL)checkTel{
    if (!self.agreeBtn.selected) {
        return NO;
    }
    
    NSString* tel= self.telTextField.text;
    if (!tel) {
        UIAlertController* alertVC=[UIAlertController   alertControllerWithTitle:@"手机格式不正确" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return NO;
    }
    NSString *phoneRegex = @"^((1[34578]))\\d{9}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(![phoneTest evaluateWithObject:tel]){
        UIAlertController* alertVC=[UIAlertController   alertControllerWithTitle:@"手机格式不正确" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
    
}

-(void)protocolBtnClick{
    WKPWebVC* webView=[[WKPWebVC alloc]init];
    webView.url=@"https://www.jianshu.com/p/6d9d6d7128d1";
    webView.title = @"用户协议";
    [self.navigationController pushViewController:webView animated:YES];
}

-(void)agreeBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
}
@end
