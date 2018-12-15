//
//  WKBrowserPhotoCollectionVCCell.m
//  WKPhotoKit
//
//  Created by wangkang on 2018/11/21.
//  Copyright © 2018 wk. All rights reserved.
//

#import "WKBrowserPhotoCollectionVCCell.h"
#import <Masonry/Masonry.h>
@interface WKBrowserPhotoCollectionVCCell()

@end
@implementation WKBrowserPhotoCollectionVCCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.scrollView=[[WKBrowserPhotoScrollView alloc]init];
        [self.contentView addSubview:self.scrollView];
        CGFloat scrollViewWidth=[UIScreen mainScreen].bounds.size.width;
        self.scrollView.frame=CGRectMake(0, 0,scrollViewWidth , self.contentView.bounds.size.height);
    }
    return self;
}
-(void)setMinZoom:(CGSize)imageSize withFrame:(CGRect)frame{
    CGRect imageRect=CGRectZero;
    imageRect.size=imageSize;
    CGFloat xValue=(frame.size.width -imageSize.width)/2.0;
    CGFloat yValue=(frame.size.height-imageSize.height)/2.0;
    imageRect.origin=CGPointMake(xValue, yValue);
    self.scrollView.browserImage.frame=imageRect;
    self.scrollView.contentSize=imageSize;
}
-(void)setMaxZoom:(CGSize)imageSize{
    CGRect imageRect=CGRectZero;
    imageRect.size=imageSize;
    self.scrollView.browserImage.frame=imageRect;
    self.scrollView.contentSize=imageSize;
}
@end
