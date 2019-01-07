//
//  WKPAddFriendVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/9.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPAddFriendVC.h"
#import "PublicHead.h"
#import "IMTools.h"
@interface WKPAddFriendVC ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation WKPAddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}
-(void)setupUI{
    
    self.userName.placeholder=NSLocalizedString(@"输入要添加的好友的手机号码",nil);
    self.message.placeholder=NSLocalizedString(@"请输入审核信息", nil);
    
    self.commitBtn.backgroundColor = BtnBgColor;
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitBtn setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
    [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.commitBtn.layer.masksToBounds=YES;
    self.commitBtn.layer.cornerRadius=5;
    self.title=NSLocalizedString(@"添加好友", nil);
}
-(void)commitBtnClick{
    NSString* userName=[NSString stringWithFormat:@"wkp%@",self.userName.text];
    IMTools* tools= [IMTools defaultInstance];
    EMError* error =[tools addContaceRequest:userName withMessage:self.message.text];
    if (error) {
        [MBProgressHUD showSuccess:error.description toView:nil];
    }else{
        [MBProgressHUD showSuccess:NSLocalizedString(@"添加好友成功", nil) toView:nil];
    }
}
@end
