//
//  WKPMessageVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/20.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPMessageVC.h"
#import "WKPMessageVCCell.h"
#import "IMTools.h"
#import "WSChatTableViewController.h"
@interface WKPMessageVC ()
@property(nonatomic,strong)NSMutableArray* dataArray;
@end

@implementation WKPMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight=55;
    [self.tableView registerNib:[UINib nibWithNibName:@"WKPMessageVCCell" bundle:nil] forCellReuseIdentifier:@"cell"];
  
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    IMTools* tools =[IMTools defaultInstance];
    self.dataArray= [NSMutableArray arrayWithArray:[tools  getAllConversation]];
    [self.dataArray sortUsingComparator:^NSComparisonResult(EMConversation*  _Nonnull obj1, EMConversation*  _Nonnull obj2) {
        EMMessage *message1 = [obj1 latestMessage];
        EMMessage *message2 = [obj2 latestMessage];
        if(message1.timestamp > message2.timestamp) {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }

    }];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKPMessageVCCell* cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    EMConversation * con= self.dataArray[indexPath.row];
    cell.con =con;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WSChatTableViewController *chat = [[WSChatTableViewController alloc]init];
    EMConversation* con = self.dataArray[indexPath.row];
    chat.con = con ;
    EMMessage* lastMessage = [con lastReceivedMessage];
    NSString* name = [lastMessage from];
    chat.userName = name;
    chat.title = [name substringFromIndex:3];
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}
-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
