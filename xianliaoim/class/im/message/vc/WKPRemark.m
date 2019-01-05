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
    self.navigationItem.title=@"添加修改";
    self.inputText.placeholder = @"请输入好友的备注";
    if (self.remark) {
        self.inputText.placeholder = self.remark.remarkName;
        self.navigationItem.title = @"备注修改";
    }

    self.btn.backgroundColor =BtnBgColor;
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn setTitle:@"确定修改" forState:UIControlStateNormal];
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
