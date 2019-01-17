//
//  UIImage+WKPImageTool.h
//  xianliaoim
//
//  Created by wangkang on 2018/12/8.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WKPImageTool)
-(UIImage *)compressOriginalImageWithSize:(CGSize)size;
-(UIImage*)imageChangeColor:(UIColor*)color;
@end

NS_ASSUME_NONNULL_END
