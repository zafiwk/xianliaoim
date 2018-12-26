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
#import "WSChatMessageMoreView.h"
#import "WKSelectPhotoPickerGroupVC.h"
#import "FWNavigationController.h"
#import "IMTools.h"
#import <CoreLocation/CoreLocation.h>
#import "PublicHead.h"
#import "WKPLocationCell.h"
#import "WKPMapVC.h"
#import "EMMessage+WKPChatModel.h"
#import <MJRefresh/MJRefresh.h>
#import "WKPImageVC.h"
#define kBkColorTableView    ([UIColor colorWithRed:0.773 green:0.855 blue:0.824 alpha:1])


@interface WSChatTableViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,WSChatMessageInputBarDelegate,WSChatVoiceTableViewCellDelegate>

@property(nonatomic,strong)WSChatMessageInputBar *inputBar;

@property(nonatomic,strong)NSMutableArray* dataArray;

@property(nonatomic,strong)CLLocationManager* locationManager;

@property(nonatomic,strong)CLGeocoder* geocoder;

@property(nonatomic,strong)MBProgressHUD* hud;

@property(nonatomic,assign)bool stopGetLocal;


@property(nonatomic,strong)EMMessage* firstMessage;

@property(nonatomic,strong)NSTimer* voiceTimer;

@property(nonatomic,assign)NSInteger voiceS;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreBtnChlick:) name:moreBtnClickNoti object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceive:) name:MessageReceive object:nil];
    
    EMMessage* lastMessage = [self.con latestMessage];
    WKPLog(@"lastMessag:%lld",lastMessage.timestamp);
    if(lastMessage){
        [self.con markMessageAsReadWithId:lastMessage.messageId error:nil];
        [self.dataArray addObject:[lastMessage model]];
        [self loadMoreMsgWithMessage:lastMessage withScrollToBottom:YES];
    }
    
    
    UITapGestureRecognizer* tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGrClick)];
    [self.tableView addGestureRecognizer:tapGR];
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
    if([model.chatCellType integerValue]==WSChatCellType_Audio){
        WSChatVoiceTableViewCell* voiceCell=(WSChatVoiceTableViewCell*)cell;
        voiceCell.delegate = self;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];
}

- (void)configureCell:(WSChatBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    WSChatModel *model = self.dataArray[indexPath.row];
    
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
        case EventChatCellImageTapedEvent:{
            NSLog(@"点击了图片了。。");
            if ([model.chatCellType  integerValue] == WSChatCellType_local) {
                WKPMapVC* vc=[[WKPMapVC alloc]init];
                vc.title = @"地理位置";
                vc.location =model.location;
                vc.localStr = model.content;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([model.chatCellType integerValue]==WSChatCellType_Image) {
                WKPImageVC* vc=[[WKPImageVC alloc]init];
                vc.model = model;
                vc.title = @"图片预览";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
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
    
    IMTools* imTools = [IMTools defaultInstance];
    [imTools sendMessageWithText:userInfo[@"text"] withUser:self.userName withConversationID:self.con.conversationId withBlock:^(id  obj, EMError *  error) {
        [self addModel:newModel];
    }];
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
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self  loadMoreMsg];
    }];
    [_tableView registerClass:[WSChatTextTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1,@(WSChatCellType_Text))];
    [_tableView registerClass:[WSChatTextTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0,@(WSChatCellType_Text))];
    
    [_tableView registerClass:[WSChatImageTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_Image))];
    [_tableView registerClass:[WSChatImageTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_Image))];
    
    [_tableView registerClass:[WSChatVoiceTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_Audio))];
    [_tableView registerClass:[WSChatVoiceTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_Audio))];
    
    [_tableView registerClass:[WKPLocationCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_local))];
    [_tableView registerClass:[WKPLocationCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_local))];
    
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
    _inputBar.delegate = self;
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
        if (row >= 1&&animated){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    });
}



-(void)loadMoreMsg{
    EMMessage* fristMessage=self.firstMessage;
    if (fristMessage) {
        [self loadMoreMsgWithMessage:fristMessage withScrollToBottom:NO];
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    
}
-(void)loadMoreMsgWithMessage:(EMMessage*)msg withScrollToBottom:(BOOL)animated{
    __weak  typeof(self) weakSelf = self;
    [self.con  loadMessagesStartFromId:msg.messageId count:10 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        if (aMessages.count==0||aError) {
            [weakSelf.tableView.mj_header endRefreshing];
            return ;
        }
        NSArray* sortArray = [aMessages sortedArrayUsingComparator:^NSComparisonResult(EMMessage*   obj1, EMMessage* obj2) {
            if (obj1.timestamp>obj2.timestamp) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
        
        
        for (NSInteger i=0; i<sortArray.count; i++) {
            EMMessage* message = sortArray[i];
//            WKPLog(@"aMessages:%lld",message.timestamp);
            [weakSelf.con   markMessageAsReadWithId:message.messageId error:nil];
            [weakSelf.dataArray insertObject:[message model] atIndex:0];
        }
        
        weakSelf.firstMessage = [aMessages firstObject];
        //        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf scrollToBottom:animated];
        //            EXC_BAD_INSTRUCTION
        //            dispatch_group_enter(self.group);
        //            dispatch_group_leave(self.group);
    }];
    
}
-(void)moreBtnChlick:(NSNotification*)noti{
    NSDictionary* user=noti.userInfo;
    NSNumber* selectIndex = user[@"selectIndex"];
    
    switch ([selectIndex integerValue]) {
        case 0:{
            __weak typeof(self) weakSelf= self;
            WKSelectPhotoPickerGroupVC* vc=[[WKSelectPhotoPickerGroupVC alloc]init];
            vc.maxValue = 9;
            vc.block = ^(NSArray *  array) {
                if (!array) {
                    return ;
                }
                
                for (NSUInteger i=0;i<array.count;i++ ) {
                    UIImage * image =array[i];
                    IMTools* tools=[IMTools defaultInstance];
                    [tools sendMessageWithUIImage:image withUser:weakSelf.userName withConversationID:weakSelf.con.conversationId withBlock:^(id  _Nonnull obj, EMError * _Nonnull error) {
                        WSChatModel *newModel = [[WSChatModel alloc]init];;
                        newModel.chatCellType = @(WSChatCellType_Image);
                        newModel.isSender     = @(YES);
                        newModel.timeStamp    = [NSDate date];
                        newModel.sendingImage =image ;
                        [self addModel:newModel];
                    }];
                }
            };
            //            [self.navigationController pushViewController:vc animated:YES];
            FWNavigationController* naviC=[[FWNavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:naviC animated:YES completion:nil];
            //照片
            NSLog(@"selectIndex:0");
        }
            break;
        case 1:{
            //电话
            IMTools* tools = [IMTools defaultInstance];
            NSString* message = [NSString stringWithFormat:@"%@发起了语音聊天",[[EMClient sharedClient] currentUsername]];
            [tools sendMessageWithText:[message substringFromIndex:3] withUser:self.userName withConversationID:self.con.conversationId withBlock:^(EMMessage* obj, EMError * _Nonnull error) {
                WSChatModel* model = [obj model];
                [self addModel:model];
                [tools sendAudioCall:self.userName];
            }];
            NSLog(@"selectIndex:1");
        }
            break;
            
        case 2:{
            IMTools* tools = [IMTools defaultInstance];
            NSString* message = [NSString stringWithFormat:@"%@发起了视频聊天",[[EMClient sharedClient] currentUsername]];
            [tools sendMessageWithText:[message  substringFromIndex:3] withUser:self.userName withConversationID:self.con.conversationId withBlock:^(EMMessage*   obj, EMError * _Nonnull error) {
                WSChatModel* model = [obj model];
                [self addModel:model];
                [tools sendVideoCall:self.userName];
            }];
            //视频电话
            NSLog(@"selectIndex:2");
        }
            break;
            
        case 3:{
            //文件
            self.locationManager  = [[CLLocationManager alloc]init];
            if ([CLLocationManager locationServicesEnabled]) {
                if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
                    [self.locationManager requestWhenInUseAuthorization];
                }else{
                    //设置定位的精确
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                    //设置最小跟新的距离
                    self.locationManager.distanceFilter = 100;
                    
                    self.locationManager.delegate= self;
                    
                    [self.locationManager startUpdatingLocation];
                    
                    self.hud = [MBProgressHUD showMessage:@"定位获取中" toView:self.view];
                }
                
                
            }else{
                
                NSURL* url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]){
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                }
                return;
            }
            
        }
            break;
            
        case 4:
            //位置
            
            break;
        default:
            break;
    }
}


#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.hud hideAnimated:YES];
    [MBProgressHUD showError:@"定位获取失败" toView:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    WKPLog(@"成功获取位置");
    if (self.stopGetLocal) {
        return ;
    }
    self.stopGetLocal = YES;
    [self.locationManager stopUpdatingLocation];
    CLLocation* location = [locations firstObject];
    self.geocoder = [[CLGeocoder alloc]init];
    __weak  typeof(self) waekSelf = self;
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        [waekSelf.hud hideAnimated:YES];
        //获取地标
        CLPlacemark* placemark = [placemarks firstObject];
        NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@",
                             placemark.thoroughfare,
                             placemark.locality,
                             placemark.subLocality,
                             placemark.administrativeArea,
                             placemark.postalCode,
                             placemark.country];
        WKPLog(@"address:%@", address);
        
        NSString* localStr=[NSString stringWithFormat:@"%@ %@ %@",placemark.administrativeArea,placemark.locality,placemark.subLocality];
        IMTools* tools=[IMTools defaultInstance];
        CLLocationCoordinate2D coordtion=location.coordinate;
        [tools sendMessageWithLatitude:coordtion.latitude withLongitude:coordtion.longitude withAddress:localStr withUser:waekSelf.userName withConversationID:waekSelf.con.conversationId withBlock:^(id  _Nonnull obj, EMError * _Nonnull error) {
            WSChatModel *newModel = [[WSChatModel alloc]init];;
            newModel.chatCellType = @(WSChatCellType_local);
            newModel.isSender     = @(YES);
            newModel.timeStamp    = [NSDate date];
            newModel.content      = localStr;
            newModel.location =location;
            [self addModel:newModel];
            waekSelf.stopGetLocal = NO;
        }];
    }];
}

-(void)messageReceive:(NSNotification*)notifaication{
    NSDictionary* info =notifaication.userInfo;
    WSChatModel* model = info[MessageWSModel];
    [self addModel:model];
}

#pragma mark WSChatMessageInputBarDelegate
-(void)voiceSavePath:(NSString*)path{
    [self.voiceTimer invalidate];
    self.voiceTimer = nil;
    if (self.voiceS<1.5) {
        [MBProgressHUD showSuccess:@"录制时间过短" toView:self.view];
        return;
    }
    IMTools* tools=[IMTools defaultInstance];
    [tools seedMessageWithVoiceLocalPath:path withDisplayName:@"语音消息" withUser:self.userName withConversationID:self.con.conversationId withInfo:@{@"time":@(self.voiceS)} withBlock:^(EMMessage* obj, EMError * _Nonnull error) {
        WSChatModel* model = [obj model];
        model.secondVoice = @(self.voiceS);
        model.content = path;
        self.voiceS = 0;
        [self addModel:model];
    }];
}
-(void)startRecord{
    self.voiceTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
         self.voiceS++;
    }];
}


-(void)addModel:(WSChatModel*)model{
    WSChatModel* lastModel = [self.dataArray lastObject];
    NSTimeInterval s =model.timeStamp.timeIntervalSince1970 - lastModel.timeStamp.timeIntervalSince1970;
    WKPLog(@"添加model时候时间的差值:%f",s);
    if (s>5*60) {
        WSChatModel* timeModel = [[WSChatModel alloc]init];
        timeModel.chatCellType = @(WSChatCellType_Time);
        NSDateFormatter* df=[[NSDateFormatter alloc]init];
        df.dateFormat=@"yyyy-MM-dd HH:mm";
        timeModel.content = [df stringFromDate:lastModel.timeStamp];
        [self.dataArray addObject:timeModel];
    }
    [self.dataArray addObject:model];
    [self scrollToBottom:YES];
}


-(void)compleRecord{
    [self.voiceTimer invalidate];
    self.voiceTimer = nil;
}
-(void)tapGrClick{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
#pragma mark WSChatVoiceTableViewCellDelegate
-(void)reloadVoiceModel:(WSChatModel*)model{
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        WSChatModel* model = self.dataArray[i];
        model.voiceIsPlay = NO;
    }
    [self.tableView reloadData];
}
@end
