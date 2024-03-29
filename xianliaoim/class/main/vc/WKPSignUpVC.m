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
    
    self.telTextField.placeholder = NSLocalizedString(@"请输入注册的手机号码", nil);
    self.passWordTextField.placeholder = NSLocalizedString(@"请输入密码", nil);
    self.yanzhengmaTextField.placeholder=NSLocalizedString(@"请输入手机验证码", nil);
    [self.cmRequestBtn setTitle:NSLocalizedString(@"短信校验", nil) forState:UIControlStateNormal];
    if (self.type==REGISTERED) {
        [self.signInBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
        self.title=NSLocalizedString(@"用户注册", nil);
    }else{
        [self.signInBtn setTitle:NSLocalizedString(@"密码修改", nil) forState:UIControlStateNormal];
        self.title=NSLocalizedString(@"密码修改", nil);
    }
    
    [self.signInBtn addTarget:self action:@selector(siginInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cmRequestBtn addTarget:self action:@selector(cmRequestBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.agreeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    self.protocolBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    self.agreeBtn.selected = YES;
    [self.agreeBtn setTitle:NSLocalizedString(@"同意", nil) forState:UIControlStateNormal];
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
    
    
    [self.protocolBtn setTitle:NSLocalizedString(@"《闲聊app用户使用协议》", nil) forState:UIControlStateNormal];
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
        [MBProgressHUD showError:NSLocalizedString(@"密码应该有数字字母组成,长度不小于8位不大于12位", nil) toView:self.view];
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
                MBProgressHUD* hud=[MBProgressHUD showMessage:NSLocalizedString(@"注册中....", nil) toView:weakSelf.view];
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
    __weak typeof(self) weakSelf = self;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.telTextField.text zone:@"86"  result:^(NSError *error) {
        if (error){
            [MBProgressHUD showSuccess:NSLocalizedString(@"未知错误稍后再试", nil) toView:weakSelf.view];
        }else{
            [MBProgressHUD showSuccess:NSLocalizedString(@"消息发送成功,短信可能存在延迟", nil) toView:self.view];
        }
    }];
    self.sTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.s--;
        if (self.s==0) {
            [self.sTimer invalidate];
            self.sTimer = nil;
            [self.cmRequestBtn setTitle:NSLocalizedString(@"短信校验", nil) forState:UIControlStateNormal];
        }else{
            [self.cmRequestBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"短信校验", nil),self.s] forState:UIControlStateNormal];
        }
    }];
}

-(BOOL)checkTel{
    if (!self.agreeBtn.selected) {
        return NO;
    }
    
    NSString* tel= self.telTextField.text;
    if (!tel) {
        UIAlertController* alertVC=[UIAlertController   alertControllerWithTitle:NSLocalizedString(@"手机格式不正确", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return NO;
    }
    NSString *phoneRegex = @"^((1[34578]))\\d{9}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(![phoneTest evaluateWithObject:tel]){
        UIAlertController* alertVC=[UIAlertController   alertControllerWithTitle:NSLocalizedString(@"手机格式不正确", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
    
}

-(void)protocolBtnClick{
    WKPWebVC* webView=[[WKPWebVC alloc]init];
    webView.url=@"https://www.jianshu.com/p/6d9d6d7128d1";
    webView.title = NSLocalizedString(@"用户协议", nil);
    [self.navigationController pushViewController:webView animated:YES];
}

-(void)agreeBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
}
@end
