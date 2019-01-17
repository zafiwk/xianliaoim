//
//  WSChatTableBaseCell.m
//  QQ
//
//  Created by weida on 15/8/15.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import "WSChatBaseTableViewCell.h"
#import "PublicHead.h"
#import <Masonry/Masonry.h>
#import "UIImage+Utils.h"
@implementation WSChatBaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {

        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        mHead = [[UIImageView alloc]init];
        mHead.backgroundColor = [UIColor clearColor];
        mHead.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headBeenTaped:)];
        [mHead addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *headlongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(headBeenLongPress:)];
        [mHead addGestureRecognizer:headlongPress];
        
        mHead.image = [UIImage imageNamed:@"user_avatar_default"];
        [self.contentView addSubview:mHead];
      
        [mHead autoSetDimensionsToSize:CGSizeMake(kWidthHead, kHeightHead)];
        mHead.layer.masksToBounds= YES;
        mHead.layer.cornerRadius=kWidthHead/2.0;
        
        [mHead autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kTopHead];
        NSArray *IDs = [reuseIdentifier componentsSeparatedByString:kReuseIDSeparate];
        
        NSAssert(IDs.count>=2, @"reuseIdentifier should be separate by -");
        
        isSender = [IDs[0] boolValue];
        
        if (isSender)//是我自己发送的
        {
//            [mHead autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kTraingHead];
            [mHead mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(-kTraingHead).priorityHigh();
            }];
            NSString* dataPath=iconPath;
            NSData* imageData = [NSData dataWithContentsOfFile:dataPath];
            if (imageData.length>0) {
                mHead.image=[UIImage imageWithData:imageData];
            }
        }else//别人发送的消息
        {
//            [mHead autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLeadingHead];
            [mHead mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(kLeadingHead);
            }];
            mHead.backgroundColor = [UIColor blueColor];
        }
        
        mBubbleImageView = [[UIImageView alloc]init];
        mBubbleImageView.backgroundColor = [UIColor clearColor];
        mBubbleImageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *bubblelongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [mBubbleImageView addGestureRecognizer:bubblelongPress];
        [self.contentView addSubview:mBubbleImageView];
        
//        [mBubbleImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:mHead withOffset:-kOffsetTopHeadToBubble];
      
       
    
        if (isSender)//是我自己发送的
        {
            [mBubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self->mHead.mas_top).offset(-kOffsetTopHeadToBubble);
            }];
            mBubbleImageView.image = [[UIImage imageNamed:kImageNameChat_send_nor] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
            
            mBubbleImageView.highlightedImage = [[UIImage imageNamed:kImageNameChat_send_press] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
            
        
            
//            [mBubbleImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:mHead withOffset:-kOffsetHHeadToBubble];
            [mBubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(self->mHead.mas_leading).offset(-kOffsetHHeadToBubble);
            }];
        }else//别人发送的消息
        {
//            [mBubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(self->mHead.mas_top).offset(-kOffsetTopHeadToBubble);
//            }];
            [mBubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self->mHead.mas_top).offset(10);
            }];
            
            
            self.nickLabel = [[UILabel alloc]init];
            self.nickLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:self.nickLabel];
            
       
            
             mBubbleImageView.image = [[UIImage imageNamed:kImageNameChat_Recieve_nor]stretchableImageWithLeftCapWidth:30 topCapHeight:30];
            mBubbleImageView.highlightedImage = [[UIImage imageNamed:kImageNameChat_Recieve_press] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
            
//            [mBubbleImageView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:mHead withOffset:kOffsetHHeadToBubble];
            [mBubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self->mHead.mas_trailing).offset(kOffsetHHeadToBubble);
            }];
        }
    }
    
    return self;
}

-(void)headBeenTaped:(UITapGestureRecognizer *)tap
{
    [self routerEventWithType:EventChatCellHeadTapedEvent userInfo:@{kModelKey:self.model}];
}

-(void)headBeenLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        [self routerEventWithType:EventChatCellHeadLongPressEvent userInfo:@{kModelKey:self.model}];
    }
   
}

-(void)longPress:(UILongPressGestureRecognizer *)Press
{
    
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

-(void)setModel:(WSChatModel *)model{
    _model = model;
    if (self.nickLabel) {
        
        if ([model.sendName hasPrefix:@"wkp"]) {
            NSString* userName = model.sendName;
            IMTools* tools = [IMTools defaultInstance];
            RemarkModel* model = [tools queryRemarkNameByName:userName];
            if (model) {
                self.nickLabel.text = model.remarkName;
            }else{
                self.nickLabel.text = [userName substringFromIndex:3];
            }
        }
       
    }
    
    mHead.tintColor  = [UIColor whiteColor];
}
@end
