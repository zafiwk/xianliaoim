//
//  WKSelectPhotoPickerGroupVC.h
//  WKPhotoKit
//
//  Created by wangkang on 2018/11/18.
//  Copyright © 2018 wk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectImagesBlock)(NSArray* array);
@interface WKSelectPhotoPickerGroupVC : UITableViewController
@property(nonatomic,strong)selectImagesBlock block;
@end

NS_ASSUME_NONNULL_END
