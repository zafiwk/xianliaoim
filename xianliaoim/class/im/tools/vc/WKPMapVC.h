//
//  WKPMapVC.h
//  xianliaoim
//
//  Created by wangkang on 2018/12/17.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface WKPMapVC : UIViewController
@property(nonatomic,strong)CLLocation* location;
@property(nonatomic,strong)NSString* localStr;
@end

NS_ASSUME_NONNULL_END
