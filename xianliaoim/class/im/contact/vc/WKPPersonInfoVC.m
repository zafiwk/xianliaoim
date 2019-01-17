//
//  WKPPersonInfoVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/29.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPPersonInfoVC.h"
#import "WKPQrCode.h"
#import "WKPRemark.h"
#import "IMTools.h"
@interface WKPPersonInfoVC ()
@property(nonatomic,strong)NSMutableArray* dataArray;
@end

@implementation WKPPersonInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=NSLocalizedString(@"设置", nil);
    [self.dataArray addObject:@[NSLocalizedString(@"好友二维码", nil)]];
    [self.dataArray addObject:@[NSLocalizedString(@"设置好友备注", nil)]];
}

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* dataArry=self.dataArray[section];
    return dataArry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray* dataArray =self.dataArray[indexPath.section];
    NSString* str=dataArray[indexPath.row];
    cell.textLabel.text= str;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            WKPQrCode* codeVC=[[WKPQrCode alloc]init];
            codeVC.qrStr=self.username;
            [self.navigationController pushViewController:codeVC animated:YES];
        }
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            WKPRemark* vc=[[WKPRemark alloc]init];
            IMTools* tools = [IMTools defaultInstance];
            vc.remark = [tools queryRemarkNameByName:self.username];
            vc.userName=self.username;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
@end
