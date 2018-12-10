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
#import "IMTools.h"
#import <Masonry/Masonry.h>
#import <FWPopupView/FWPopupView-Swift.h>
#import "WKPAddFriendVC.h"
#import "WKPAddFriendRequestVC.h"
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
    
    if([[EMClient sharedClient] isLoggedIn]){
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [btn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        UIBarButtonItem* rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem=rightBtnItem;
        self.numLabel=[[UILabel alloc]init];
        self.numLabel.backgroundColor=[UIColor redColor];
        self.numLabel.font = [UIFont systemFontOfSize:13];
        self.numLabel.textAlignment=NSTextAlignmentCenter;
        self.numLabel.textColor = [UIColor whiteColor];
        [btn addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(13);
            make.top.mas_equalTo(-13);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        self.numLabel.layer.masksToBounds=YES;
        self.numLabel.layer.cornerRadius=10;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
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
        NSArray* friendsRequestList=[tools getAllRequest];
        if (friendsRequestList.count==0) {
            self.numLabel.hidden=YES;
        }else{
            self.numLabel.hidden=NO;
            self.numLabel.text =[NSString stringWithFormat:@"%ld",friendsRequestList.count];
        }
    }else{
        VisitoeView*  view=[VisitoeView visitoeView];
        view.frame=self.view.bounds;
        [view setupVisitoeViewWithTitle:@"登入可以查看消息" imageName:@"visitordiscover_image_message"];
        self.tableView.backgroundView=view;
        self.tableView.tableFooterView=[[UIView  alloc]init];
        [view.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        self.notData=YES;
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
        return 2;
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
//                if (self.contactArray.count==0) {
        WKPShowMessageCell* cell=[tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
        cell.messageLabel.text=@"你还没有添加任何好友";
        cell.messageLabel.textColor =[UIColor grayColor];
        return cell;
//                }
    }else{
        WKPShowMessageCell* cell=[tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
        cell.messageLabel.text=@"你还没有加入任何群";
        cell.messageLabel.textColor =[UIColor grayColor];
        return cell;
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
    
    FWMenuView *menuView = [FWMenuView menuWithItemTitles:@[@"添加好友/群",@"扫一扫",@"好友验证消息"] itemImageNames:@[[UIImage imageNamed:@"right_menu_addFri"],[UIImage imageNamed:@"right_menu_QR"],[UIImage imageNamed:@"right_menu_multichat"]] itemBlock:^(FWPopupView *popupView, NSInteger index, NSString *title) {
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
    }
}


@end
