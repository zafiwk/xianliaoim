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
#import "WSChatMessageMoreView.h"
#import "WKSelectPhotoPickerGroupVC.h"
#import "FWNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "PublicHead.h"
#import "WKPLocationCell.h"
#import "WKPMapVC.h"
#import "EMMessage+WKPChatModel.h"
#import <MJRefresh/MJRefresh.h>
#import "WKPImageVC.h"
#import "WKPPersonInfoVC.h"
#import "WKPVideoCell.h"
#import "NSString+WKPCategory.h"
#import "WKPGroupInfo.h"
#define kBkColorTableView    ([UIColor colorWithRed:0.773 green:0.855 blue:0.824 alpha:1])


@interface WSChatTableViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,WSChatMessageInputBarDelegate,WSChatVoiceTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

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

- (void)viewDidLoad{
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

    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iStreamline"] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    self.navigationItem.rightBarButtonItem=rightItem;
    rightItem.tintColor = [UIColor whiteColor];


    self.locationManager  = [[CLLocationManager alloc]init];

    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    WKPLog(@"WSChatTableViewController   ----dealloc");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.con.type == EMConversationTypeChat) {
        IMTools* tools = [IMTools defaultInstance];
        RemarkModel* model = [tools queryRemarkNameByName:self.userName];
        if (model) {
            self.navigationItem.title = model.remarkName;
        }
    }
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
                vc.title = NSLocalizedString(@"地理位置", nil);
                vc.location =model.location;
                vc.localStr = model.content;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([model.chatCellType integerValue]==WSChatCellType_Image) {
                WKPImageVC* vc=[[WKPImageVC alloc]init];
                vc.model = model;
                vc.title = NSLocalizedString(@"图片预览", nil);
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            if([model.chatCellType integerValue]==WSChatCellType_Video){
                //                MPMoviePlayerViewController* vc=nil; 被弃用 使用AVPlayerViewController
                EMMessageBody *msgBody = model.message.body;
                EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
                WKPLog(@"model:%@ downloadStatus:%d",model.content,body.downloadStatus);
                
                NSFileManager* fileManager = [NSFileManager defaultManager];
                if (body.downloadStatus ==EMDownloadStatusSucceed&&[fileManager fileExistsAtPath:model.content]) {
                    [self playVideoWithPath:model.content];
                }else{
                    WKPLog(@"需要下载短视频");
                    __weak  typeof(self) weakSelf  = self;
                    MBProgressHUD* hud=[MBProgressHUD showMessage:NSLocalizedString(@"视频下载中", nil) toView:self.view];
                    //                    [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
                    //
                    //                    }];
                    [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:^(int progress) {
                        
                    } completion:^(EMMessage *message, EMError *error) {
                        [hud hideAnimated:YES];
                        if (error) {
                            [MBProgressHUD showError:NSLocalizedString(@"视频下载失败", nil) toView:weakSelf.view];
                            return ;
                        }
                        WSChatModel* chatModel = [message model];
                        model.message=message;
                        model.content = chatModel.content;
                        [self playVideoWithPath:chatModel.content];
                        WKPLog(@"下载好了视频");
                    }];
                }
                
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

-(void)playVideoWithPath:(NSString*)path{
    NSURL * url = [NSURL fileURLWithPath:path];
    WKPLog(@"播放的url:%@",[url  path]);
    AVPlayer* player=[[AVPlayer alloc]initWithURL:url];
    AVPlayerViewController  *vc=[[AVPlayerViewController alloc]init];
    vc.player = player;
    [vc.player play];
    vc.modalPresentationStyle  =  UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)pickerImages:(NSInteger)maxCount{
    WKPLog(@"pickerImages:%ld",maxCount);
    //    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    //    pickerVc.status = PickerViewShowStatusCameraRoll;// 默认显示相册里面的内容SavePhotos
    //    pickerVc.maxCount = maxCount;
    //    [pickerVc showPickerVc:self];
    //    __weak typeof(self) weakSelf = self;
    //    pickerVc.callBack = ^(NSArray *assets)
    //    {
    //        for (MLSelectPhotoAssets *image in assets)
    //        {
    //            WSChatModel *newModel = [[WSChatModel alloc]init];
    //            newModel.chatCellType = @(WSChatCellType_Image);
    //            newModel.isSender     = @(YES);
    //            newModel.timeStamp    = [NSDate date];
    //            newModel.sendingImage = image.thumbImage;
    //            NSLog(@"%@",image.assetURL);
    //        }
    //
    //
    //    };
    
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
    if (self.con.type == EMConversationTypeChat) {
        [imTools sendMessageWithText:userInfo[@"text"] withUser:self.userName withConversationID:self.con.conversationId withBlock:^(id  obj, EMError *  error) {
            [self addModel:newModel];
        }];
    }else{
        [imTools sendGroupMessageWithText:userInfo[@"text"] withUser:self.group   withConversationID:self.con.conversationId withBlock:^(id  _Nonnull obj, EMError * _Nonnull error) {
            [self addModel:newModel];
        }];
    }
    
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
    
    __weak  typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf  loadMoreMsg];
    }];
    [_tableView registerClass:[WSChatTextTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1,@(WSChatCellType_Text))];
    [_tableView registerClass:[WSChatTextTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0,@(WSChatCellType_Text))];
    
    [_tableView registerClass:[WSChatImageTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_Image))];
    [_tableView registerClass:[WSChatImageTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_Image))];
    
    [_tableView registerClass:[WSChatVoiceTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_Audio))];
    [_tableView registerClass:[WSChatVoiceTableViewCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_Audio))];
    
    [_tableView registerClass:[WKPLocationCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_local))];
    [_tableView registerClass:[WKPLocationCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_local))];
    //WKPVideoCell
    [_tableView registerClass:[WKPVideoCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@0, @(WSChatCellType_Video))];
    [_tableView registerClass:[WKPVideoCell class] forCellReuseIdentifier:kCellReuseIDWithSenderAndType(@1, @(WSChatCellType_Video))];
    
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
    _inputBar.con  =self.con;
    return _inputBar;
}

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}


-(void)scrollToBottom:(BOOL)animated{    //让其滚动到底部
    //GCD释放了block 强引用不会导致内存泄露
    __weak  typeof(self) weakSelf  = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
        NSInteger row = weakSelf.dataArray.count;
        if (row >= 1&&animated){
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
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
                    if (self.con.type == EMConversationTypeChat) {
                        [tools sendMessageWithUIImage:image withUser:weakSelf.userName withConversationID:weakSelf.con.conversationId withBlock:^(id  _Nonnull obj, EMError * _Nonnull error) {
                            WSChatModel *newModel = [[WSChatModel alloc]init];;
                            newModel.chatCellType = @(WSChatCellType_Image);
                            newModel.isSender     = @(YES);
                            newModel.timeStamp    = [NSDate date];
                            newModel.sendingImage =image ;
                            [self addModel:newModel];
                        }];
                    }else{
                        [tools sendGroupMessageWithUIImage:image withUser:self.group withConversationID:weakSelf.con.conversationId withBlock:^(id  _Nonnull obj, EMError * _Nonnull error) {
                            WSChatModel *newModel = [[WSChatModel alloc]init];;
                            newModel.chatCellType = @(WSChatCellType_Image);
                            newModel.isSender     = @(YES);
                            newModel.timeStamp    = [NSDate date];
                            newModel.sendingImage =image ;
                            [self addModel:newModel];
                        }];
                    }
                }
            };
            //            [self.navigationController pushViewController:vc animated:YES];
            FWNavigationController* naviC=[[FWNavigationController alloc]initWithRootViewController:vc];
            naviC.modalPresentationStyle  =  UIModalPresentationFullScreen;
            [self presentViewController:naviC animated:YES completion:nil];
            //照片
            NSLog(@"selectIndex:0");
        }
            break;
        case 1:{
            //电话
            NSLog(@"self.con.type=================>%d",self.con.type);
            if(self.con.type == EMConversationTypeChat){
                [self sendVoiceChat];
            }else{
                [self sendLocal];
            }
        }
            break;
            
        case 2:{
            if(self.con.type == EMConversationTypeChat){
                [self sendVideoChat];
            }else{
                [self sendVideo];
            }
        }
            break;
            
        case 3:{
            [self sendLocal];
        }
            break;
            
        case 4:{
            [self sendVideo];
        }
            break;
            
        default:
            break;
    }
}

-(void)sendVoiceChat{
    IMTools* tools = [IMTools defaultInstance];
    NSString* message = [NSString stringWithFormat:@"%@%@",[[EMClient sharedClient] currentUsername],NSLocalizedString(@"发起了语音聊天", nil)];
    [tools sendMessageWithText:[message substringFromIndex:3] withUser:self.userName withConversationID:self.con.conversationId withBlock:^(EMMessage* obj, EMError * _Nonnull error) {
        WSChatModel* model = [obj model];
        [self addModel:model];
        [tools sendAudioCall:self.userName];
    }];
    NSLog(@"selectIndex:1");
}
-(void)sendVideoChat{
    IMTools* tools = [IMTools defaultInstance];
    NSString* message = [NSString stringWithFormat:@"%@%@",[[EMClient sharedClient] currentUsername],NSLocalizedString(@"发起了视频聊天", nil)];
    [tools sendMessageWithText:[message  substringFromIndex:3] withUser:self.userName withConversationID:self.con.conversationId withBlock:^(EMMessage*   obj, EMError * _Nonnull error) {
        WSChatModel* model = [obj model];
        [self addModel:model];
        [tools sendVideoCall:self.userName];
    }];
    //视频电话
    NSLog(@"selectIndex:2");
}

-(void)sendLocal{
    if ([CLLocationManager locationServicesEnabled]) {
        //设置定位的精确
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置最小跟新的距离
        self.locationManager.distanceFilter = 100;
        self.locationManager.delegate= self;
        [self.locationManager startUpdatingLocation];
        self.hud = [MBProgressHUD showMessage:NSLocalizedString(@"定位获取中", nil) toView:self.view];
    }else{
        
        //                NSURL* url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        //                if([[UIApplication sharedApplication] canOpenURL:url]){
        //                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        //
        //                    }];
        //                }
        //                return;
        [MBProgressHUD showError:NSLocalizedString(@"请在设置中打开定位", nil) toView:self.view];
    }
}
-(void)sendVideo{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return;
    }
    UIImagePickerController* imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate =self;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//设置后置摄像头
    imagePicker.mediaTypes =@[(NSString*)kUTTypeMovie];//默认是图片这里设置movie
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头是录像模式
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;//设置视频质量
    imagePicker.modalPresentationStyle  =  UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.hud hideAnimated:YES];
    [MBProgressHUD showError:NSLocalizedString(@"定位获取失败", nil) toView:self.view];
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
        
        if (self.con.type == EMConversationTypeChat) {
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
        }else{
            [tools sendGroupMessageWithLatitude:coordtion.latitude withLongitude:coordtion.longitude withAddress:localStr withUser:waekSelf.group withConversationID:waekSelf.con.conversationId withBlock:^(id  _Nonnull obj, EMError * _Nonnull error) {
                WSChatModel *newModel = [[WSChatModel alloc]init];;
                newModel.chatCellType = @(WSChatCellType_local);
                newModel.isSender     = @(YES);
                newModel.timeStamp    = [NSDate date];
                newModel.content      = localStr;
                newModel.location =location;
                [self addModel:newModel];
                waekSelf.stopGetLocal = NO;
            }];
        }
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
    if (self.voiceS<1.0) {
        [MBProgressHUD showSuccess:NSLocalizedString(@"录制时间过短", nil) toView:self.view];
        return;
    }
    
    IMTools* tools=[IMTools defaultInstance];
    
    if (self.con.type ==EMConversationTypeChat) {
        [tools sendMessageWithVoiceLocalPath:path withDisplayName:@"语音消息" withUser:self.userName withConversationID:self.con.conversationId withInfo:@{@"time":@(self.voiceS)} withBlock:^(EMMessage* obj, EMError * _Nonnull error) {
            WSChatModel* model = [obj model];
            model.secondVoice = @(self.voiceS);
            model.content = path;
            self.voiceS = 0;
            [self addModel:model];
        }];
    }else{
        [tools sendGroupMessageWithVoiceLocalPath:path withDisplayName:@"语音消息" withUser:self.group withConversationID:self.con.conversationId withInfo:@{@"time":@(self.voiceS)} withBlock:^(EMMessage* obj, EMError * _Nonnull error) {
            WSChatModel* model = [obj model];
            model.secondVoice = @(self.voiceS);
            model.content = path;
            self.voiceS = 0;
            [self addModel:model];
        }];
    }
    
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
    if (s>5*60&&lastModel) {
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

#pragma  mark setting
-(void)setting{
    if (self.con.type ==EMConversationTypeChat) {
        WKPPersonInfoVC* vc=[[WKPPersonInfoVC alloc]initWithStyle:UITableViewStyleGrouped];
        vc.username=self.userName;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        WKPGroupInfo* vc=[[WKPGroupInfo alloc]initWithStyle:UITableViewStyleGrouped];
        vc.group = self.group;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    WKPLog(@"info:%@",info);
    NSURL* fileUrl =info[@"UIImagePickerControllerMediaURL"];
    NSString* docPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* videoHome = [docPath stringByAppendingPathComponent:@"videoHome"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:videoHome]) {
        [fileManager  createDirectoryAtPath:videoHome withIntermediateDirectories:YES attributes:@{} error:nil];
    }
    
    NSString* filePath = [[videoHome stringByAppendingPathComponent:[NSString uuidString]] stringByAppendingPathExtension:@"MP4"];
    WKPLog(@"本地的实际路劲:%@",filePath);
    //    filePath = [filePath  stringByDeletingPathExtension];
    //    filePath = [filePath stringByAppendingPathExtension:@"MP4"];
    //    NSURL* newFileUrl = [[NSURL alloc]initFileURLWithPath:filePath];
    //    [fileManager copyItemAtURL:fileUrl toURL:newFileUrl error:nil];
    //  转MP4
    [self fileLocalPath:fileUrl toNewPath:filePath];
    
    
}

-(void)fileLocalPath:(NSURL*)locaUrl toNewPath:(NSString*)newPath{
    
    AVURLAsset* avAsset = [AVURLAsset URLAssetWithURL:locaUrl options:nil];
    NSArray* compatibleWithAsset=[AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if([compatibleWithAsset containsObject:AVAssetExportPresetMediumQuality]){
        AVAssetExportSession* exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        NSURL* newUrl = [NSURL fileURLWithPath:newPath];
        exportSession.outputURL =newUrl;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType =AVFileTypeMPEG4;
        //初始化型号量 设置同时完成的个数
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            //提高信号量 信号量加1
            dispatch_semaphore_signal(wait);
        }];
        //等待降低信号量
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
            if (wait) {
                wait =  nil;
            }
            [MBProgressHUD showError:NSLocalizedString(@"消息发送失败", nil) toView:self.view];
            return;
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
            NSURL* newFileUrl = [[NSURL alloc]initFileURLWithPath:newPath];
            IMTools* tools=[IMTools defaultInstance];
            if (self.con.type == EMConversationTypeChat) {
                [tools sendMessageWithVideoLocalPath:[newFileUrl path] withDisplayName:@"video.mp4" withUser:self.userName withConversationID:self.con.conversationId withBlock:^(EMMessage * obj, EMError * _Nonnull error) {
                    WSChatModel* model = [obj model];
                    [self addModel:model];
                }];
            }else{
                [tools sendGroupMessageWithVideoLocalPath:[newFileUrl path] withDisplayName:@"video.mp4" withUser:self.group withConversationID:self.con.conversationId withBlock:^(EMMessage * obj, EMError * _Nonnull error) {
                    WSChatModel* model = [obj model];
                    [self addModel:model];
                }];
            }
        }
    }
    
}



@end
