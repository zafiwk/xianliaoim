//
//  WKPWebVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/7.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPWebVC.h"
#import <Masonry/Masonry.h>
#import <WebKit/WebKit.h>
@interface WKPWebVC ()
@property(nonatomic,strong)WKWebView* web;
@end

@implementation WKPWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.web = [[WKWebView alloc]init];
    [self.view addSubview:self.web];
    [self.web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.web loadRequest:request];
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
