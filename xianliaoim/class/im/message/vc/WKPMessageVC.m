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
#import "WKPWebVC.h"
@interface WKPMessageVC ()
@property(nonatomic,strong)NSMutableArray* dataArray;
@end

@implementation WKPMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight=55;
    [self.tableView registerNib:[UINib nibWithNibName:@"WKPMessageVCCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unRead:) name:MessageUnRead object:nil];
    
}
//弹出隐私条款
-(void)alertMessage{
    UIAlertController* alertVC=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"用户使用协议和隐私条款提示", nil) message:NSLocalizedString(@"本应用尊重并保护所有使用服务用户的个人隐私权。为了给您提供更准确、更有个性化的服务，本应用会按照本隐私权政策的规定使用和披露您的个人信息。但本应用将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，在未征得您事先许可的情况下，本应用不会将这些信息对外披露或向第三方提供。本应用会不时更新本隐私权政策。 您在同意本应用服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于本应用服务使用协议不可分割的一部分。", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction  actionWithTitle:NSLocalizedString(@"同意用户使用协议和用户隐私条款", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"frist" forKey:@"frist"];
        [defaults synchronize];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"查看用户使用协议", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WKPWebVC* webVC=[[WKPWebVC alloc]init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.title =NSLocalizedString(@"用户使用协议", nil);
        webVC.url=@"https://www.jianshu.com/p/6d9d6d7128d1";
        [self.navigationController pushViewController:webVC animated:YES];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"查看隐私条款", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WKPWebVC* webVC=[[WKPWebVC alloc]init];
        webVC.hidesBottomBarWhenPushed=YES;
        webVC.title =NSLocalizedString(@"隐私条款", nil);
        webVC.url=@"https://www.jianshu.com/p/98be1a49a90e";
        [self.navigationController pushViewController:webVC animated:YES];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"不同意用户使用协议和用户隐私条款", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self alertMessage1];
    }]];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}
//第二次
-(void)alertMessage1{
    UIAlertController* alertVC=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"用户使用协议和隐式条款提示", nil) message:NSLocalizedString(@"闲聊将按照用户使用协议和隐私条款提供服务。如果不同意,可以点击\"不同意\"退出应用。", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"在想想", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self alertMessage];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"不同意并退出", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        abort();
    }]];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* frist=[defaults stringForKey:@"frist"];
    if (frist.length == 0) {
        [self alertMessage];
    }
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
        
        
        NSInteger maxUnRead=0;
        for (NSInteger i=0; i<dataArray.count; i++) {
            EMConversation* con = dataArray[i];
            maxUnRead += [con  unreadMessagesCount];
        }
        
        if (maxUnRead>0) {
            self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%ld",maxUnRead];
            [UIApplication sharedApplication].applicationIconBadgeNumber=maxUnRead;
        }else{
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        }
        
        
        self.tableView.backgroundView=nil;
    }else{
        VisitoeView*  view=[VisitoeView visitoeView];
        view.frame=self.view.bounds;
        [view setupVisitoeViewWithTitle:NSLocalizedString(@"登录后可以查看消息,尝试登录下吧", nil) imageName:@"visitordiscover_image_message"];
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

#pragma mark 通知
-(void)unRead:(NSNotification*)noti{
    NSDictionary*  userInfo = noti.userInfo;
    NSNumber* unReadCount = userInfo[MessageUnReadCount];
    self.tabBarItem.badgeValue = [unReadCount stringValue];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [unReadCount integerValue];
}
@end
