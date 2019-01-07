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
#import "WKPSignInVC.h"
@interface WKPMeVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
    [self.dataSource addObject:@[NSLocalizedString(@"修改昵称", nil),@"绑定微博账号",@"个人图片"]];
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
        NSString* imagePath = iconPath;
        NSData* imageData=[NSData dataWithContentsOfFile:imagePath];
        WKPLog(@"imageData.length%ld",imageData.length);
        if (imageData.length>0) {
            cell.userIcon.image = [UIImage imageWithData:imageData];
        }
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
           NSString* currentUsername= [[EMClient sharedClient] currentUsername];
            cell.detailTextLabel.text = [currentUsername substringFromIndex:3];
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
        if (![EMClient sharedClient].isLoggedIn) {
            WKPSignInVC* loginVC=[[WKPSignInVC alloc]init];
            loginVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        if (indexPath.row==0) {
//            MBProgressHUD* hud=[MBProgressHUD showMessage:@"删除中...." toView:self.view];
            SDImageCache* cache=[SDImageCache sharedImageCache];
            [cache clearMemory];
            [cache clearDiskOnCompletion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
//                      [hud hideAnimated:YES];
                    [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
                });
            }];
        }else{
            IMTools* tools= [IMTools defaultInstance];
            NSArray* allConversation=[tools  getAllConversation];
            for (NSInteger i=0; i<allConversation.count; i++) {
                EMConversation* con=allConversation[i];
                [con deleteAllMessages:nil];
            }
            NSString* docPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString* recordHome = [docPath stringByAppendingPathComponent:@"record"];
            NSFileManager* manager = [NSFileManager defaultManager];
            [manager removeItemAtPath:recordHome error:nil];
            [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
        }
        return;
    }
    
    if(indexPath.section == 1){
        if (![EMClient sharedClient].isLoggedIn) {
            WKPSignInVC* loginVC=[[WKPSignInVC alloc]init];
            loginVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        WKPQrCode* vc=[[WKPQrCode alloc]init];
        NSString* loginName=[[EMClient sharedClient] currentUsername];
        vc.qrStr = loginName;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if (![EMClient sharedClient].isLoggedIn) {
                WKPSignInVC* loginVC=[[WKPSignInVC alloc]init];
                loginVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            WKPChangNickVC* vc=[[WKPChangNickVC alloc]init];
            vc.title=@"设置昵称";
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==1){
            WKPBindWeibo* vc=[[WKPBindWeibo alloc]init];
            vc.title=@"账号绑定";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertController* alertVC=[UIAlertController alertControllerWithTitle:@"选择图片的方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    return ;
                }
                UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
                
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
                    return ;
                }
                UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertVC animated:YES completion:^{
                
            }];
            
        }
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage* image=info[UIImagePickerControllerOriginalImage];
    NSData* imageData = UIImageJPEGRepresentation(image, 0.3);
    NSString* imagePath =iconPath;
    [imageData writeToFile:imagePath atomically:YES];
    [self.tableView reloadData];
//    WKPLog(@"info:%@",info);
}
@end
