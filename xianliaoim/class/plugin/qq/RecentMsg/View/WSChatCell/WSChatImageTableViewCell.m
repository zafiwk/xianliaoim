//
//  WSChatImageTableViewCell.m
//  QQ
//
//  Created by weida on 15/8/17.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import "WSChatImageTableViewCell.h"
#import "PureLayout.h"
#import "UIImageView+WebCache.h"
#import "PublicHead.h"
#import <Masonry/Masonry.h>
//文本
#define kH_OffsetTextWithHead        (20)//水平方向文本和头像的距离
#define kMaxOffsetText               (45)//文本最长时，为了不让文本分行显示，需要和屏幕对面保持一定距离
#define kTop_OffsetTextWithHead      (15) //文本和头像顶部对其间距
#define kBottom_OffsetTextWithSupView   (40)//文本与父视图底部间距

#define kMaxHeightImageView            (200)

@interface WSChatImageTableViewCell ()
{
    /**
     *  @brief  图片所在ImageView
     */
    UIImageView *mImageView;
}
@end


@implementation WSChatImageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        mBubbleImageView.image = [UIImage imageNamed:@""];
        mImageView = [UIImageView newAutoLayoutView];
        mImageView.contentMode = UIViewContentModeScaleAspectFit;
        mImageView.backgroundColor = [UIColor clearColor];
        mImageView.userInteractionEnabled = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageBeenTaped:)];
        [mBubbleImageView addGestureRecognizer:tap];
        
//        [self.contentView insertSubview:mImageView atIndex:0];
        [self.contentView addSubview:mImageView];
        if (isSender)//是我自己发送的
        {
            [mBubbleImageView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:mImageView withOffset:0];
        }else//别人发送的消息
        {
            [mBubbleImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:mImageView withOffset:0];
        }
        
        [mBubbleImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:mImageView withOffset:0];
        
        CGFloat top     = kTopHead - kOffsetTopHeadToBubble;
        CGFloat bottom  = kBottom_OffsetTextWithSupView;
        CGFloat leading = kOffsetHHeadToBubble + kWidthHead + kLeadingHead;
        CGFloat traing  = kMaxOffsetText;
        
        [mImageView autoSetDimension:ALDimensionHeight toSize:kMaxHeightImageView relation:NSLayoutRelationLessThanOrEqual];
        
        UIEdgeInsets inset;
        if (isSender)//是自己发送的消息
        {
            inset = UIEdgeInsetsMake(top, traing, bottom, leading);

            [mImageView autoPinEdgesToSuperviewEdgesWithInsets:inset excludingEdge:ALEdgeLeading];

            [mImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:traing relation:NSLayoutRelationGreaterThanOrEqual];
            
            
        }else//是对方发送的消息
        {
            top=top+30;
            inset = UIEdgeInsetsMake(top, leading, bottom, traing);
            
            [mImageView autoPinEdgesToSuperviewEdgesWithInsets:inset excludingEdge:ALEdgeTrailing];

            [mImageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:traing relation:NSLayoutRelationGreaterThanOrEqual];
            
            [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self->mHead.mas_top).offset(0);
                make.left.mas_equalTo(self->mBubbleImageView.mas_left);
                make.right.mas_equalTo(-20);
                make.height.mas_equalTo(15);
            }];
        }
    }
    
    return self;
}
-(UIImageView*)getMImageView{
    return mImageView;
}
-(UIEdgeInsets)imageEdge{
    UIEdgeInsets inset;
    CGFloat top     = kTopHead - kOffsetTopHeadToBubble;
    CGFloat bottom  = kBottom_OffsetTextWithSupView;
    CGFloat leading = kOffsetHHeadToBubble + kWidthHead + kLeadingHead;
    CGFloat traing  = kMaxOffsetText;
    if ([self.model.isSender boolValue]) {
        inset = UIEdgeInsetsMake(top, traing, bottom, leading);
    }else{
        inset = UIEdgeInsetsMake(top, leading, bottom, traing);
    }
    
    return inset;
}

-(void)setModel:(WSChatModel *)model
{
    if (model.sendingImage){
        mImageView.image = model.sendingImage;
    }else{
        [mImageView sd_setImageWithURL:[NSURL URLWithString:model.remotePath] placeholderImage:[UIImage imageNamed:@"picture"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                WKPLog(@"图片cell中高清图片下载失败");
            }
        }];
    }
    [super setModel:model];
}


-(void)imageBeenTaped:(UITapGestureRecognizer*)tap
{
    [self routerEventWithType:EventChatCellImageTapedEvent userInfo:@{kModelKey:self.model}];
}

-(void)longPress:(UILongPressGestureRecognizer *)Press
{
    if (Press.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        
//        UIMenuItem *copy = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(menuCopy:)];
//        UIMenuItem *remove = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(menuRemove:)];
//        
//        UIMenuController *menu = [UIMenuController sharedMenuController];
//        [menu setMenuItems:@[copy,remove]];
//        [menu setTargetRect:mBubbleImageView.frame inView:self];
//        [menu setMenuVisible:YES animated:YES];
        
    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return  ((action == @selector(menuCopy:))  || (action == @selector(menuRemove:)));
}


#pragma mark --复制、删除处理
-(void)menuCopy:(id)sender
{
    [UIPasteboard generalPasteboard].image = mImageView.image;
}

-(void)menuRemove:(id)sender
{
    [self routerEventWithType:EventChatCellRemoveEvent userInfo:@{kModelKey:self.model}];
}

@end
