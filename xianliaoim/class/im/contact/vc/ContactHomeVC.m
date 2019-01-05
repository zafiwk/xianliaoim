//
//  ContactHomeVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/11/28.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "ContactHomeVC.h"
#import "PublicHead.h"
#import "WKPSignUpVC.h"
#import "WKPSignInVC.h"
#import <Hyphenate/Hyphenate.h>
#import "WKPShowMessageCell.h"
#import <Masonry/Masonry.h>
#import <FWPopupView/FWPopupView-Swift.h>
#import "WKPAddFriendVC.h"
#import "WKPAddFriendRequestVC.h"
#import "ZFScanViewController.h"
#import "NSString+WKPCategory.h"
#import "ContactVCCell.h"
#import "WSChatTableViewController.h"
#import "IMTools.h"
@interface ContactHomeVC ()
@property(nonatomic,strong)NSMutableArray* contactArray;
@property(nonatomic,strong)NSMutableArray* groupArray;
@property(nonatomic,assign)BOOL notData;
@property(nonatomic,strong)UILabel* numLabel;
@end

@implementation ContactHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    [self.tableView registerNib:[UINib nibWithNibName:@"WKPShowMessageCell" bundle:nil] forCellReuseIdentifier:@"messageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactVCCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.numLabel=[[UILabel alloc]init];
    self.numLabel.backgroundColor=[UIColor redColor];
    self.numLabel.font = [UIFont systemFontOfSize:13];
    self.numLabel.textAlignment=NSTextAlignmentCenter;
    self.numLabel.textColor = [UIColor whiteColor];
    self.numLabel.layer.masksToBounds=YES;
    self.numLabel.layer.cornerRadius=10;
    
    self.tableView.rowHeight= 44;
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupDataSource];
}

-(void)setupDataSource{
    
     if([[EMClient sharedClient] isLoggedIn]){
         IMTools* tools=[IMTools defaultInstance];
         self.tableView.backgroundView=nil;
         self.contactArray=[NSMutableArray arrayWithArray:[tools getAllContacts]];
         self.notData=NO;
         
         
         UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
         [btn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
         UIBarButtonItem* rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
         [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         self.navigationItem.rightBarButtonItem=rightBtnItem;
         NSArray* allRequests=[tools  getAllRequest];
         if (allRequests.count==0) {
             [self.numLabel removeFromSuperview];
         }else{
             [btn addSubview:self.numLabel];
             [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.right.mas_equalTo(13);
                 make.top.mas_equalTo(-13);
                 make.width.mas_equalTo(20);
                 make.height.mas_equalTo(20);
             }];
             self.numLabel.text = [NSString stringWithFormat:@"%ld",allRequests.count];
         }
     }else{
        VisitoeView*  view=[VisitoeView visitoeView];
        view.frame=self.view.bounds;
        [view setupVisitoeViewWithTitle:@"登录后可以查看好友,尝试登录下吧" imageName:@"visitordiscover_image_message"];
        self.tableView.backgroundView=view;
        self.tableView.tableFooterView=[[UIView  alloc]init];
        [view.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        self.notData=YES;
         
         [self.numLabel removeFromSuperview];
         self.navigationItem.rightBarButtonItem = nil ;
     }
    [self.tableView reloadData];
}
#pragma mark get方法
-(NSMutableArray*)contactArray{
    if (!_contactArray) {
        _contactArray=[NSMutableArray array];
    }
    return _contactArray;
}
-(NSMutableArray*)groupArray{
    if (!_groupArray) {
        _groupArray=[NSMutableArray  array];
    }
    return _groupArray;
}
#pragma mark -登入按钮事件
-(void)loginClick{
    WKPSignInVC* loginVC=[[WKPSignInVC alloc]init];
    loginVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.notData) {
        return 0;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        if (self.contactArray.count==0) {
            return 1;
        }else{
            return self.contactArray.count;
        }
    }else{
        if(self.groupArray.count==0){
            return 1;
        }else{
            return self.groupArray.count;
        }
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.notData) {
        return 0;
    }else{
        return 20;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"好友列表";
    }else{
        return @"群列表";
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (self.contactArray.count==0) {
            WKPShowMessageCell* cell=[tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
            cell.messageLabel.text=@"你还没有添加任何好友";
            cell.messageLabel.textColor =[UIColor grayColor];
            return cell;
        }else{
            ContactVCCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//            NSString* userName = [self.contactArray[indexPath.row] substringFromIndex:3];
//            cell.nameLabel.text = userName;
            NSString* userName =self.contactArray[indexPath.row];
            
            IMTools* tools = [IMTools defaultInstance];
            RemarkModel* model = [tools queryRemarkNameByName:userName];
            if (model) {
                cell.nameLabel.text = model.remarkName;
            }else{
                cell.nameLabel.text = [userName substringFromIndex:3];
            }
            
            return cell;
        }
        
    }else{
        if (self.groupArray.count==0) {
            WKPShowMessageCell* cell=[tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
            cell.messageLabel.text=@"你还没有加入任何群";
            cell.messageLabel.textColor =[UIColor grayColor];
            return cell;
        }else{
            ContactVCCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            return cell;
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if(self.contactArray.count==0){
            return;
        }
        WSChatTableViewController *chat = [[WSChatTableViewController alloc]init];
        NSString* userName = self.contactArray[indexPath.row];
        chat.userName = userName;
        chat.title = [userName substringFromIndex:3];
        IMTools* imools = [IMTools defaultInstance];
        chat.con = [imools createConversationWithUser:userName];
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];

    }else{
        
    }
}
#pragma mark btnClick
-(void)topBtnClick:(UIButton*)btn{
    CGFloat kStatusAndNavBarHeight = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    FWMenuViewProperty *property = [[FWMenuViewProperty alloc] init];
    property.popupCustomAlignment = FWPopupCustomAlignmentTopRight;
    property.popupAnimationType = FWPopupAnimationTypeScale;
    property.popupArrowStyle = FWMenuArrowStyleRound;
    property.touchWildToHide = @"1";
    property.topBottomMargin = 0;
    property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.3];
    property.popupViewEdgeInsets = UIEdgeInsetsMake(kStatusAndNavBarHeight, 0, 0, 8);
    property.popupArrowVertexScaleX = 1;
    property.animationDuration = 0.2;
    
    FWMenuView *menuView = [FWMenuView menuWithItemTitles:@[@"添加好友",@"扫一扫",@"好友验证消息"] itemImageNames:@[[UIImage imageNamed:@"right_menu_addFri"],[UIImage imageNamed:@"right_menu_QR"],[UIImage imageNamed:@"right_menu_multichat"]] itemBlock:^(FWPopupView *popupView, NSInteger index, NSString *title) {
        [self  fWMenuViewClick:index];
    } property:property];
    
    [menuView show];
}

-(void)fWMenuViewClick:(NSInteger)index{
    if (index==0) {
        WKPAddFriendVC* vc=[[WKPAddFriendVC alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index==2){
        WKPAddFriendRequestVC* vc=[[WKPAddFriendRequestVC alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        ZFScanViewController* vc=[[ZFScanViewController alloc]init];
        __weak  typeof(self) weakSelf=self;
        vc.returnScanBarCodeValue = ^(NSString *barCodeString) {
            NSString* tel=nil;
            if ([barCodeString hasPrefix:@"wkp"]) {
                tel=[barCodeString substringFromIndex:3];
            }else{
               [MBProgressHUD showError:@"不支持的二维码" toView:weakSelf.view];
                return ;
            }
            BOOL d=[tel checkTel];
            if (d) {
                IMTools* tools=[IMTools defaultInstance];
                [tools addContaceRequest:barCodeString withMessage:@""];
            }else{
                [MBProgressHUD showError:@"不支持的二维码" toView:weakSelf.view];
            }
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(UISwipeActionsConfiguration*)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSString* userName = self.contactArray[indexPath.row];
        IMTools* tools = [IMTools defaultInstance];
        [tools deleteContact:userName];
        [self setupDataSource];
    }];
    
    UISwipeActionsConfiguration* config=[UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return config;
}
@end
