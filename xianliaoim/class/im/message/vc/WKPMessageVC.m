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
#import "PublicHead.h"
#import "WKPSignInVC.h"
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
    if([[EMClient sharedClient] isLoggedIn]){
        IMTools* tools =[IMTools defaultInstance];
        self.dataArray= [NSMutableArray array];
        NSArray* dataArray=[tools  getAllConversation];
        for (NSInteger i=0; i<dataArray.count; i++) {
            EMConversation* con = dataArray[i];
            EMMessage* lastMessage  = [con latestMessage];
            if (lastMessage) {
                [self.dataArray addObject:con];
            }
        }
        [self.dataArray sortUsingComparator:^NSComparisonResult(EMConversation*  _Nonnull obj1, EMConversation*  _Nonnull obj2) {
            EMMessage *message1 = [obj1 latestMessage];
            EMMessage *message2 = [obj2 latestMessage];
            if(message1.timestamp > message2.timestamp) {
                return(NSComparisonResult)NSOrderedAscending;
            }else {
                return(NSComparisonResult)NSOrderedDescending;
            }
            
        }];
        self.tableView.backgroundView=nil;
    }else{
        VisitoeView*  view=[VisitoeView visitoeView];
        view.frame=self.view.bounds;
        [view setupVisitoeViewWithTitle:@"登录后可以查看消息,尝试登录下吧" imageName:@"visitordiscover_image_message"];
        self.tableView.backgroundView=view;
        self.tableView.tableFooterView=[[UIView  alloc]init];
        [view.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
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
    EMMessage* lastMessage = [con latestMessage];
    NSString* currentName = [EMClient sharedClient].currentUsername;
    NSString* name = nil;
    if ([lastMessage.to isEqualToString:currentName]) {
        name = lastMessage.from;
    }else{
        name= lastMessage.to;
    }
    
    chat.userName = name;
    chat.title = [name substringFromIndex:3];
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}
-(UISwipeActionsConfiguration*)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        EMConversation* con = self.dataArray[indexPath.row];
        IMTools* tools= [IMTools defaultInstance];
        [tools deleteConversation:@[con] withBlock:^(id  _Nonnull obj, EMError * _Nonnull error) {
            [self.dataArray removeObject:con];
            [self.tableView reloadData];
        }];
    }];
    
    UISwipeActionsConfiguration* config=[UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return config;
}
-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark -登入按钮事件
-(void)loginClick{
    WKPSignInVC* loginVC=[[WKPSignInVC alloc]init];
    loginVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
@end
