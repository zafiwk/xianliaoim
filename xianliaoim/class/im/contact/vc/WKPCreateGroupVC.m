//
//  WKPCreateGroupVC.m
//  xianliaoim
//
//  Created by wangkang on 2019/1/16.
//  Copyright © 2019 wangkang. All rights reserved.
//

#import "WKPCreateGroupVC.h"
#import <Masonry/Masonry.h>
#import "PublicHead.h"
#import "WKPCreateGroupVCCell.h"
#import "IMTools.h"
@interface WKPCreateGroupVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITextField* groupName;
@property(nonatomic,strong)UIButton*  createGroupBtn;
@property(nonatomic,strong)UITableView* contactArrayView;
@property(nonatomic,strong)NSArray* dataArray;
@property(nonatomic,strong)NSMutableArray* selectArray;
@end

@implementation WKPCreateGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    IMTools* tools = [IMTools defaultInstance];
    self.dataArray = [tools  getAllContacts];
    
}


-(void)setupView{
    
    self.view.backgroundColor  = [UIColor whiteColor];
    self.navigationItem.title = @"创建群聊";
    [self.view addSubview:self.groupName];
    [self.groupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(40);
        make.top.mas_offset(30);
        make.right.mas_offset(-40);
        make.height.mas_offset(40);
    }];
    
    [self.view addSubview:self.createGroupBtn];
    [self.createGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(40);
        make.top.mas_equalTo(self.groupName.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    
    [self.view addSubview:self.contactArrayView];
    [self.contactArrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.createGroupBtn.mas_bottom).offset(50);
    }];
}


-(UITextField*)groupName{
    if (!_groupName) {
        _groupName = [[UITextField alloc]init];
        _groupName.placeholder = @"群名称";
        _groupName.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _groupName;
}
-(UIButton*)createGroupBtn{
    if (!_createGroupBtn) {
        _createGroupBtn = [[UIButton alloc]init];
        [_createGroupBtn setTitle:@"创建群聊" forState:UIControlStateNormal];
        _createGroupBtn.backgroundColor =BtnBgColor;
        [_createGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _createGroupBtn.layer.masksToBounds=YES;
        _createGroupBtn.layer.cornerRadius = 5;
        [_createGroupBtn addTarget:self action:@selector(createGroupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createGroupBtn;
}

-(UITableView*)contactArrayView{
    if (!_contactArrayView) {
        _contactArrayView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contactArrayView.delegate = self;
        _contactArrayView.dataSource = self;
        [_contactArrayView registerNib:[UINib nibWithNibName:@"WKPCreateGroupVCCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _contactArrayView.tableFooterView = [[UIView alloc]init];
    }
    return _contactArrayView;
}
-(NSMutableArray*)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKPCreateGroupVCCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString* userName =self.dataArray[indexPath.row];
    IMTools* tools = [IMTools defaultInstance];
    RemarkModel* model = [tools queryRemarkNameByName:userName];
    if (model) {
        cell.name.text = model.remarkName;
    }else{
        cell.name.text = [userName substringFromIndex:3];
    }
    
    if ([self.selectArray containsObject:userName]) {
        cell.select.image = [UIImage imageNamed:@"qb_tenpay_checkbox_checked"];
    }else{
        cell.select.image = [UIImage imageNamed:@"qb_tenpay_checkbox_normal"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* userName =self.dataArray[indexPath.row];
    if ([self.selectArray containsObject:userName]) {
        [self.selectArray removeObject:userName];
    }else{
        [self.selectArray addObject:userName];
    }
    [self.contactArrayView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIWidth, 20)];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:view.bounds];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.text =@"勾选邀请入群的好友";
    [view  addSubview:titleLabel];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(void)createGroupBtnClick{
    if (self.groupName.text.length==0) {
        [MBProgressHUD showError:@"请填写群名称" toView:self.view];
    }
    
    MBProgressHUD* hud  = [MBProgressHUD showMessage:@"群创建中" toView:self.view];
    EMError *error = nil;
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = 500;
    setting.IsInviteNeedConfirm = NO; //邀请群成员时，是否需要发送邀请通知.若NO，被邀请的人自动加入群组
    setting.style = EMGroupStylePublicJoinNeedApproval;// 创建不同类型的群组，这里需要才传入不同的类型
    EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:self.groupName.text description:@"群组描述" invitees:self.selectArray message:@"邀请您加入群组" setting:setting error:&error];
    [hud hideAnimated:YES];
    if(!error){
        NSLog(@"创建成功 -- %@",group);
        [self.navigationController popToRootViewControllerAnimated:YES];
        [MBProgressHUD showSuccess:@"创建成功" toView:nil];
    }else{
        [MBProgressHUD showMessage:@"创建失败" toView:self.view];
    }
}
@end
