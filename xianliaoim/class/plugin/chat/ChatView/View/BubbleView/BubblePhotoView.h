//
//  BubbleImageView.h
//  KeyBoardView
//
//  Created by joy_yu on 16/3/21.

//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface BubblePhotoView : UIView


@property(nonatomic,strong) MessageModel *message;


+ (instancetype)BubblePhotoView;

+ (CGSize)bubblePhotoWithMessage:(MessageModel *)model;

@end
