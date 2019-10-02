//
//  WKPQrCode.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/8.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPQrCode.h"
#import <Hyphenate/Hyphenate.h>
#import <Masonry/Masonry.h>
#import <CoreImage/CoreImage.h>
#import "PublicHead.h"
@interface WKPQrCode ()
@property(nonatomic,strong)UIImageView* qrImage;
@end

@implementation WKPQrCode

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupUI];
    [self setupQR];
    
}
-(void)setupUI{
    self.title=@"二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.qrImage = [[UIImageView alloc]init];
    [self.view addSubview:self.qrImage];
    [self.qrImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
}

-(void)setupQR{
    
  
   
    
    CIFilter* filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];;
    
    [filter setDefaults];
    
    NSData* data=[self.qrStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage* outputImage = [filter outputImage];
    
    self.qrImage.image = [self creatNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
}


/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成高清的UIImage
 */
- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
