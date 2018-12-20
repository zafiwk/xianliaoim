//
//  WSChatTableViewController.h
//  QQ
//
//  Created by weida on 15/8/15.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import <UIKit/UIKit.h>
#import <Hyphenate/Hyphenate.h>
@class NSFetchedResultsController;

/**
 *  @brief  聊天窗口
 */
@interface WSChatTableViewController : UIViewController
{
    UITableView                *_tableView;
}

@property(nonatomic,strong,readonly)UITableView  *tableView;
@property(nonatomic,strong)EMConversation* con;
@property(nonatomic,strong)NSString* userName;
@end
