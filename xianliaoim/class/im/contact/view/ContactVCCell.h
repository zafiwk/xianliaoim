//
//  ContactVCCell.h
//  xianliaoim
//
//  Created by wangkang on 2018/11/28.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactVCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;

@end

NS_ASSUME_NONNULL_END
