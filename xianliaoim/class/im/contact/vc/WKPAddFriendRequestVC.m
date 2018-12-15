//
//  WKPAddFriendRequestVC.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/9.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPAddFriendRequestVC.h"
#import "WKPAddFriendRequestVCCell.h"
#import "WKPShowMessageCell.h"


@interface WKPAddFriendRequestVC ()
@property(nonatomic,strong)NSArray* dataArray;
@end

@implementation WKPAddFriendRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.tableView registerNib:[UINib nibWithNibName:@"WKPAddFriendRequestVCCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WKPShowMessageCell" bundle:nil] forCellReuseIdentifier:@"message"];
    
    self.tableView.rowHeight=100;
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    self.navigationItem.title=@"好友审核";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count==0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count==0) {
        WKPShowMessageCell* cell=[tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
        cell.messageLabel.text=@"没有好友请求";
        return cell;
    }else{
        WKPAddFriendRequestVCCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
       
        cell.agree.tag = indexPath.row;
        cell.Refuse.tag=indexPath.row;
        
        cell.agree.tag = indexPath.row;
        [cell.agree addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.Refuse.tag = indexPath.row;
        [cell.Refuse addTarget:self action:@selector(refuseClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
        
        
}
-(void)agreeClick:(UIButton*)btn{
    NSInteger row=btn.tag;
  
    [self.tableView reloadData];
}
-(void)refuseClick:(UIButton*)btn{
    NSInteger row=btn.tag;
   
    [self.tableView reloadData];
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
