//
//  WKPAddFriendRequestVCCell.h
//  xianliaoim
//
//  Created by wangkang on 2018/12/9.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKPAddFriendRequestVCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *agree;
@property (weak, nonatomic) IBOutlet UIButton *Refuse;

@end

NS_ASSUME_NONNULL_END
