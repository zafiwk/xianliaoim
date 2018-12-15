//
//  WSChatTableViewController.m
//  QQ
//
//  Created by weida on 15/8/15.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import "WSChatTableViewController.h"
#import "WSChatModel.h"
#import "WSChatTextTableViewCell.h"
#import "WSChatImageTableViewCell.h"
#import "WSChatVoiceTableViewCell.h"
#import "WSChatTimeTableViewCell.h"
#import "WSChatMessageInputBar.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "WSChatTableViewController+MoreViewClick.h"
#import "ODRefreshControl.h"
#import "WSChatMessageMoreView.h"
#import "WKSelectPhotoPickerGroupVC.h"
#import "FWNavigationController.h"

#define kBkColorTableView    ([UIColor colorWithRed:0.773 green:0.855 blue:0.824 alpha:1])


@interface WSChatTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)WSChatMessageInputBar *inputBar;

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation WSChatTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:inset excludingEdge:ALEdgeBottom];
    
    
    [self.view addSubview:self.inputBar];
    [self.inputBar autoPinEdgesToSuperviewEdgesWithInsets:inset excludingEdge:ALEdgeTop];
    [self.inputBar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tableView];
    
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"自动发消息" style:UIBarButtonItemStyleDone target:self action:@selector(testInserNewobject)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreBtnChlick:) name:moreBtnClickNoti object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self scrollToBottom:NO];
}

#pragma mark - TableView Delegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSChatModel *model = self.dataArray[indexPath.row];
    
    CGFloat height = model.height.floatValue;
    
    if (!height)
    {
        height = [tableView fd_heightForCellWithIdentifier:kCellReuseID(model) configuration:^(WSChatBaseTableViewCell* cell)
                  {
                      [cell setModel:model];
                  }];
        
        model.height = @(height);
        
    }
    
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSChatModel *model = self.dataArray[indexPath.row];
    
    WSChatBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseID(model) forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];
}

- (void)configureCell:(WSChatBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    WSChatModel *model = [[WSChatModel alloc]init];
    
    cell.model = model;
}

#pragma mark - UIResponder actions
-(void)routerEventWithType:(EventChatCellType)eventType userInfo:(NSDictionary *)userInfo
{
    WSChatModel *model = [userInfo objectForKey:kModelKey];
    
    switch (eventType)
    {
        case EventChatCellTypeSendMsgEvent:
            
            [self.view endEditing:YES];
            [self SendMessage:userInfo];
            
            break;
        case EventChatCellRemoveEvent:
            
            //            [self RemoveModel:model];
            
            break;
        case EventChatCellImageTapedEvent:
            NSLog(@"点击了图片了。。");
            
            break;
        case EventChatCellHeadTapedEvent:
            NSLog(@"头像被点击了。。。");
            break;
        case EventChatCellHeadLongPressEvent:
            NSLog(@"头像被长按了。。。。");
            break;
        case EventChatMoreViewPickerImage://选择图片
            [self pickerImages:9];
            break;
        default:
            break;
    }
    
}


-(void)SendMessage:(NSDictionary*)userInfo{
    WSChatModel* newModel = [[WSChatModel alloc]init];
    newModel.chatCellType = userInfo[@"type"];
    newModel.isSender     = @(YES);
    newModel.timeStamp    = [NSDate date];
    
    switch ([newModel.chatCellType integerValue]){
        case WSChatCellType_Text:
            
            newModel.content      = userInfo[@"text"];
            
            break;
            
        default:
            break;
    }
//    IMTools* imTools = [IMTools defaultInstance];
//    [imTools sendMessageWithText:userInfo[@"text"] withUser:self.userName withConversationID:self.con.conversationId withBlock:^(id  obj, EMError *  error) {
//
//    }];
    
  
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"要发送的消息"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    NSString*  userName= [@"WKP" stringByAppendingString:self.userName];
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.con.conversationId from:from to:userName body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
            [self.dataArray addObject:newModel];
            [self scrollToBottom:YES];
            NSLog(@"消息发送了");
        }];
    });
   
}


#pragma mark - Getter Method

-(UITableView *)tableView
{
    if (_tableView)
    {
        return _tableView;
    }
    
    _tableView                      =   [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.fd_debugLogEnabled   =   NO;
    _tableView.separatorStyle       =   UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor      =   kBkColorTableView;
    _tableView.delegate             =   self;
    _tableView.dataSource           =   self;
    _tableView.keyboardDismissMode  =   UIScrollViewKeyboardDismissModeOnDrag;
    
    _refreshControl                 =  [[ODRefreshControl alloc]initInScrollView:_tableView];
    [_refreshControl addTarget:self action:@selector(loadMoreMsg) forControlEvents:UIControlEventValueChanged];
    
    [_tableView registerClass:[WSChatTextTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1,@(WSChatCellType_Text))];
    [_tableView registerClass:[WSChatTextTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0,@(WSChatCellType_Text))];
    
    [_tableView registerClass:[WSChatImageTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_Image))];
    [_tableView registerClass:[WSChatImageTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_Image))];
    
    [_tableView registerClass:[WSChatVoiceTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_Audio))];
    [_tableView registerClass:[WSChatVoiceTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_Audio))];
    
    [_tableView registerClass:[WSChatImageTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_local))];
    [_tableView registerClass:[WSChatImageTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_local))];
    
    [_tableView registerClass:[WSChatTimeTableViewCell class] forCellReuseIdentifier:kTimeCellReusedID];
    
    return _tableView;
}

-(WSChatMessageInputBar *)inputBar
{
    if (_inputBar) {
        return _inputBar;
    }
    
    _inputBar = [[WSChatMessageInputBar alloc]init];
    _inputBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    return _inputBar;
}

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}


-(void)scrollToBottom:(BOOL)animated{    //让其滚动到底部
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        NSInteger row = self.dataArray.count;
        if (row >= 1){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    });
}



-(void)loadMoreMsg{
    
}

-(void)moreBtnChlick:(NSNotification*)noti{
    NSDictionary* user=noti.userInfo;
    NSNumber* selectIndex = user[@"selectIndex"];
    
    switch ([selectIndex integerValue]) {
        case 0:{
            WKSelectPhotoPickerGroupVC* vc=[[WKSelectPhotoPickerGroupVC alloc]init];
            vc.maxValue = 9;
            vc.block = ^(NSArray *  array) {
                if (!array) {
                    return ;
                }
                for (NSInteger i=0; i++; i<array.count) {
                  
                }
            };
            //            [self.navigationController pushViewController:vc animated:YES];
            FWNavigationController* naviC=[[FWNavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:naviC animated:YES completion:nil];
            //照片
            NSLog(@"selectIndex:0");
        }
            break;
        case 1:
            //电话
            NSLog(@"selectIndex:1");
            break;
            
        case 2:
            //视频电话
            NSLog(@"selectIndex:2");
            break;
            
        case 3:
            //文件
            NSLog(@"selectIndex:3");
            break;
            
        case 4:
            //位置
            NSLog(@"selectIndex:4");
            break;
        default:
            break;
    }
}
@end
