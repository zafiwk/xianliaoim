//
//  WKPVideoCell.m
//  xianliaoim
//
//  Created by wangkang on 2019/1/13.
//  Copyright © 2019 wangkang. All rights reserved.
//

#import "WKPVideoCell.h"
#import <Masonry/Masonry.h>
@interface WKPVideoCell()
@property(nonatomic,strong)UIButton* playBtn;
@end
@implementation WKPVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.playBtn = [[UIButton alloc]init];
        [self.playBtn setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.playBtn];
        UIImageView* imageView =  [self getMImageView];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView.mas_centerX);
            make.centerY.mas_equalTo(imageView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 300));
        }];
    }
    return self;
}

-(void)setModel:(WSChatModel *)model{
    [super setModel:model];
}
@end
