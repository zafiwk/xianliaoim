//
//  WKPImageVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/22.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPImageVC.h"
#import "UIImageView+WebCache.h"
#import "PublicHead.h"
@interface WKPImageVC ()
@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation WKPImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.model.sendingImage){
        self.imageView.image = self.model.sendingImage;
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.remotePath] placeholderImage:[UIImage imageNamed:@"picture"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                WKPLog(@"图片cell中高清图片下载失败");
            }
        }];
    }
}

-(UIImageView*)imageView{
    if (!_imageView) {
        CGFloat h = UIHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,UIWidth,h)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
@end
