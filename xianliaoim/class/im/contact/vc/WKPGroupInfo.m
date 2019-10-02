//
//  WKPGroupInfo.m
//  xianliaoim
//
//  Created by wangkang on 2019/1/16.
//  Copyright © 2019 wangkang. All rights reserved.
//

#import "WKPGroupInfo.h"
#import "WKPGroupMembersVC.h"
@interface WKPGroupInfo ()
@property(nonatomic,strong)NSArray* dataArray;
@end

@implementation WKPGroupInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=NSLocalizedString(@"设置", nil);
    NSString* currentUsername = [[EMClient sharedClient] currentUsername];
    if ([self.group.owner isEqualToString:currentUsername]) {
        self.dataArray = @[NSLocalizedString(@"成员管理", nil)];
    }else{
        self.dataArray =  @[NSLocalizedString(@"成员列表", nil)];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSString* text = self.dataArray[indexPath.section];
    cell.textLabel.text =text;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WKPGroupMembersVC* vc=[[WKPGroupMembersVC alloc]initWithStyle:UITableViewStyleGrouped];
    vc.group = self.group;
    vc.navigationItem.title  = self.dataArray[indexPath.section];
    [self.navigationController  pushViewController:vc animated:YES];
    
}
@end
