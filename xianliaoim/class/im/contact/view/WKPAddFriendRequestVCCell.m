//
//  WKPAddFriendRequestVCCell.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/9.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPAddFriendRequestVCCell.h"
#import "PublicHead.h"
@implementation WKPAddFriendRequestVCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.message.textColor=[UIColor grayColor];
    self.agree.backgroundColor =BtnBgColor;
    [self.agree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.agree setTitle:@"同意" forState:UIControlStateNormal];
    self.agree.layer.masksToBounds=YES;
    self.agree.layer.cornerRadius=5;
    self.Refuse.backgroundColor=BtnBgColor;
    [self.Refuse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.Refuse setTitle:@"拒绝" forState:UIControlStateNormal];
    self.Refuse.layer.masksToBounds=YES;
    self.Refuse.layer.cornerRadius=5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
