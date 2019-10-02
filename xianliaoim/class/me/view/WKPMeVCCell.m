//
//  WKPMeVCCell.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/7.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPMeVCCell.h"

@implementation WKPMeVCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.userIcon.layer.masksToBounds=YES;
    self.userIcon.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
