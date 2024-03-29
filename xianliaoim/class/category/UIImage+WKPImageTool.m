//
//  UIImage+WKPImageTool.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/8.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "UIImage+WKPImageTool.h"

@implementation UIImage (WKPImageTool)
-(UIImage *)compressOriginalImageWithSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}
-(UIImage*)imageChangeColor:(UIColor*)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    [color setFill];
    CGRect bounds = CGRectMake(0,0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
