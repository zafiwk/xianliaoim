//
//  WKPAddFriendRequestVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/9.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPAddFriendRequestVC.h"
#import "WKPAddFriendRequestVCCell.h"
#import "WKPShowMessageCell.h"
#import "RequestModel.h"
#import "IMTools.h"
@interface WKPAddFriendRequestVC ()
@property(nonatomic,strong)NSArray* dataArray;
@end

@implementation WKPAddFriendRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.tableView registerNib:[UINib nibWithNibName:@"WKPAddFriendRequestVCCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WKPShowMessageCell" bundle:nil] forCellReuseIdentifier:@"message"];
    
    self.tableView.rowHeight=100;
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    self.navigationItem.title=NSLocalizedString(@"好友审核", nil);
    IMTools* tools= [IMTools defaultInstance];
    self.dataArray = [tools getAllRequest];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count==0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count==0) {
        WKPShowMessageCell* cell=[tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
        cell.messageLabel.text=NSLocalizedString(@"没有好友请求", nil);
        return cell;
    }else{
        WKPAddFriendRequestVCCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
       
        
        RequestModel* mode=self.dataArray[indexPath.row];
        cell.username.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"用户名",nil),[mode.username substringFromIndex:3]];
        
        cell.message.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"审核消息",nil),mode.message];
        
        cell.agree.tag = indexPath.row;
        cell.Refuse.tag=indexPath.row;
        
        cell.agree.tag = indexPath.row;
        [cell.agree addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.Refuse.tag = indexPath.row;
        [cell.Refuse addTarget:self action:@selector(refuseClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
        
        
}
-(void)agreeClick:(UIButton*)btn{
    NSInteger row=btn.tag;
    RequestModel* model  = self.dataArray[row];
    IMTools* tools= [IMTools defaultInstance];
    [tools acceptRequest:model];
    self.dataArray = [tools getAllRequest];
    [self.tableView reloadData];
}
-(void)refuseClick:(UIButton*)btn{
    NSInteger row=btn.tag;
    RequestModel* model  = self.dataArray[row];
    IMTools* tools= [IMTools defaultInstance];
    [tools declineInvitationForUsername:model];
    self.dataArray = [tools getAllRequest];
    [self.tableView reloadData];
}

@end
