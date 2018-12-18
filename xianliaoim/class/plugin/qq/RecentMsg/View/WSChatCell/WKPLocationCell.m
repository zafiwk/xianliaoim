//
//  WKPLocationCell.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/17.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPLocationCell.h"
#import <Masonry/Masonry.h>
@interface WKPLocationCell()
@property(nonatomic,strong)UILabel* text;
@end
@implementation WKPLocationCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.text = [[UILabel alloc]init];
        [self.contentView addSubview:self.text];
        UIImageView* mImageView = [self getMImageView];
        [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(mImageView.mas_left);
            make.right.mas_equalTo(mImageView.mas_right);
            make.bottom.mas_equalTo(mImageView.mas_bottom);
            make.height.mas_equalTo(16);
        }];
        self.text.font = [UIFont systemFontOfSize:15];
        self.text.textAlignment=NSTextAlignmentCenter;
        self.text.textColor = [UIColor whiteColor];
    }
    return self;
}
-(void)setModel:(WSChatModel *)model
{
    model.sendingImage =  [UIImage imageNamed:@"chat_location_preview"];
    self.text.text=model.content;
    [super setModel:model];

}

@end
