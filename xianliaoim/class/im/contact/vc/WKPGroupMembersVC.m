//
//  WKPGroupMembersVC.m
//  xianliaoim
//
//  Created by wangkang on 2019/1/16.
//  Copyright © 2019 wangkang. All rights reserved.
//

#import "WKPGroupMembersVC.h"
#import "PublicHead.h"
#import "WKPCreateGroupVCCell.h"
@interface WKPGroupMembersVC ()
@property(nonatomic,strong)NSMutableArray* dataArray;
@end

@implementation WKPGroupMembersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    
    MBProgressHUD* hud  =[MBProgressHUD showMessage:NSLocalizedString(@"成员列表查询中", nil) toView:self.view];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WKPCreateGroupVCCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    __weak  typeof(self) weakSelf = self;
    [[EMClient sharedClient].groupManager  getGroupMemberListFromServerWithId:self.group.groupId cursor:nil pageSize:1000 completion:^(EMCursorResult *aResult, EMError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [weakSelf.dataArray addObjectsFromArray:aResult.list];
            [weakSelf.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* currentUsername = [[EMClient sharedClient] currentUsername];
    if ([self.group.owner isEqualToString:currentUsername]) {
        WKPCreateGroupVCCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        NSString* name =self.dataArray[indexPath.section];
        cell.name.text  = [name substringFromIndex:3];
        
        IMTools* imTools = [IMTools defaultInstance];
        NSArray *  allContacts = [imTools  getAllContacts];
        if ([allContacts containsObject:name]) {
            cell.select.image = [UIImage imageNamed:@"qb_tenpay_checkbox_checked"];
        }else{
            cell.select.image = [UIImage imageNamed:@"qb_tenpay_checkbox_normal"];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.text =  [self.dataArray[indexPath.section] substringFromIndex:3];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(UISwipeActionsConfiguration*)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString* currentUsername = [[EMClient sharedClient] currentUsername];
       if (![self.group.owner isEqualToString:currentUsername]) {
           return  nil;
       }
     __weak  typeof(self) weakSelf = self;
    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSString* name  = weakSelf.dataArray[indexPath.section];
        [[EMClient sharedClient].groupManager removeMembers:@[name] fromGroup:weakSelf.group.groupId completion:^(EMGroup *aGroup, EMError *aError) {
            [MBProgressHUD showSuccess:NSLocalizedString(@"删除成功", nil) toView:weakSelf.view];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    UISwipeActionsConfiguration* config=[UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return config;
}
@end
