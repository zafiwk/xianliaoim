//
//  WKPMeVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/7.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPMeVC.h"
#import "WKPMeVCCell.h"
#import "WKPWebVC.h"
#import "PublicHead.h"
#import "IMTools.h"
#import "WKPQrCode.h"
#import <SDWebImage/SDImageCache.h>
#import "WKPChangNickVC.h"
#import "UserProfileManager.h"
#import "WKPBindWeibo.h"
@interface WKPMeVC ()
@property(nonatomic,strong)NSMutableArray* dataSource;
@end

@implementation WKPMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupUI];
}

-(void)setupUI{
    [self.tableView registerNib:[UINib nibWithNibName:@"WKPMeVCCell" bundle:nil] forCellReuseIdentifier:@"iconCell"];
    self.tableView.rowHeight=44;
}
-(void)setupDataSource{
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:@[@"修改昵称",@"绑定微博账号",@"个人图片"]];
    [self.dataSource addObject:@[@"个人二维码"]];
    [self.dataSource addObject:@[@"删除缓存图片",@"删除所有聊天记录"]];
    [self.dataSource addObject:@[@"用户使用协议",@"隐私条款"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* dataSource = self.dataSource[section];
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0&indexPath.row==2) {
        WKPMeVCCell* cell=[tableView dequeueReusableCellWithIdentifier:@"iconCell" forIndexPath:indexPath];
        cell.textLabel.text=@"个人图片";
        return cell;
    }else{
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
           
        }
        
        NSArray* dataSource=self.dataSource[indexPath.section];
        cell.textLabel.text=dataSource[indexPath.row];
        
        
        if (indexPath.row==0&&indexPath.section==0) {
            UserProfileManager* manager=[UserProfileManager sharedInstance];
            NSString* loginName= [[EMClient sharedClient] currentUsername];
            cell.detailTextLabel.text = [manager  getNickNameWithUsername:loginName];
        }else{
            cell.detailTextLabel.text = nil;
        }
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3) {
        WKPWebVC* webView=[[WKPWebVC alloc]init];
        NSArray* dataSource=self.dataSource[indexPath.section];
        if (indexPath.row==0) {
            webView.url=@"https://www.jianshu.com/p/6d9d6d7128d1";
        }else{
            webView.url=@"https://www.jianshu.com/p/98be1a49a90e";
        }
        webView.title = dataSource[indexPath.row];
        [self.navigationController pushViewController:webView animated:YES];
        return;
    }
    
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            MBProgressHUD* hud=[MBProgressHUD showMessage:@"删除中" toView:nil];
            SDImageCache* cache=[SDImageCache sharedImageCache];
            [cache clearMemory];
            [cache clearDiskOnCompletion:^{
                [hud hideAnimated:YES];
            }];
        }else{
            IMTools* tools=[IMTools defaultInstance];
            NSArray *conversations = [tools getAllConversation];
            for (NSInteger i=0; i<conversations.count;i++ ) {
                EMConversation* con=conversations[i];
                [con deleteAllMessages:nil];
            }
            [MBProgressHUD showSuccess:@"删除h成功" toView:self.view];
        }
        return;
    }
    
    if(indexPath.section == 1){
        WKPQrCode* vc=[[WKPQrCode alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            WKPChangNickVC* vc=[[WKPChangNickVC alloc]init];
            vc.title=@"设置昵称";
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==1){
            WKPBindWeibo* vc=[[WKPBindWeibo alloc]init];
            vc.title=@"账号绑定";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
