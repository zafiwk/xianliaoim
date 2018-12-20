//
//  WKPMessageVCCell.h
//  xianliaoim
//
//  Created by wangkang on 2018/12/20.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMTools.h"
NS_ASSUME_NONNULL_BEGIN

@interface WKPMessageVCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property(nonatomic,strong)UILabel* num;
@property(nonatomic,strong)EMConversation* con;
@end

NS_ASSUME_NONNULL_END
