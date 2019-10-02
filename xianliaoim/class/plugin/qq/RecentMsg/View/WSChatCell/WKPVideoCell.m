//
//  WKPVideoCell.m
//  xianliaoim
//
//  Created by wangkang on 2019/1/13.
//  Copyright © 2019 wangkang. All rights reserved.
//

#import "WKPVideoCell.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import "PublicHead.h"
@interface WKPVideoCell()
@property(nonatomic,strong)UIImageView* playBtn;
@property(nonatomic,strong)AVPlayer* player;
@property(nonatomic,strong)AVPlayerLayer* playLayer;
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
        self.playBtn = [[UIImageView alloc]init];
        self.playBtn.image = [UIImage imageNamed:@"video"];
        [self.contentView addSubview:self.playBtn];
        UIImageView* imageView =  [self getMImageView];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView.mas_centerX);
            make.centerY.mas_equalTo(imageView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        
//        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(240, 200));
//        }];
        
//        [self.playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setModel:(WSChatModel *)model{
    [super setModel:model];
}
-(void)playBtnClick{
    
//    //本地播放
//    AVPlayerItem* item=nil;
//    if (self.model.content) {
//        NSString* filePath = self.model.content;
//        NSURL* url =[[NSURL alloc]initFileURLWithPath:filePath];
//        item = [AVPlayerItem playerItemWithURL:url];
//        WKPLog(@"本地的播放路劲:%@",self.model.content);
//    }else{
//        item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.model.videoRemotePath]];
//        WKPLog(@"远程的播放路劲:%@",self.model.videoRemotePath);
//    }
//    self.player = [AVPlayer playerWithPlayerItem:item];
//    AVPlayerLayer* playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    self.playLayer = playLayer;
//    UIImageView* bgImageView=[self  getMImageView];
//    bgImageView.hidden=YES;
//    playLayer.frame = bgImageView.frame;
//    [self.contentView.layer addSublayer:playLayer];
//    [self.player play];
//    self.playBtn.hidden = YES;
//
}

-(void)stopPlay{
//    [self.player pause];
//    self.playBtn.hidden  = NO;
//    [self.playLayer removeFromSuperlayer];
//    UIImageView* bgImageView=[self  getMImageView];
//    bgImageView.hidden=NO;
}
@end
