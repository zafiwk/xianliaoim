//
//  WKPRemark.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/29.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPRemark.h"
#import "PublicHead.h"
#import "IMTools.h"
@interface WKPRemark ()
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation WKPRemark

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=NSLocalizedString(@"添加修改", nil);
    self.inputText.placeholder = NSLocalizedString(@"请输入好友的备注", nl);
    if (self.remark) {
        self.inputText.placeholder = self.remark.remarkName;
        self.navigationItem.title = NSLocalizedString(@"备注修改", nil);
    }

    self.btn.backgroundColor =BtnBgColor;
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn setTitle:NSLocalizedString(@"确定修改", nil) forState:UIControlStateNormal];
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 5;
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnClick{
    IMTools* tools = [IMTools defaultInstance];
    if (self.remark) {
        [tools updateRemarkName:self.inputText.text withName:self.userName];
    }else{
        RemarkModel* remarkModel = [[RemarkModel alloc]init];
        remarkModel.remarkName= self.inputText.text;
        remarkModel.name = self.userName;
        [tools  insertRemarkModel:remarkModel];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
