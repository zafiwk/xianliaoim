//
//  WKPMessageVCCell.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/20.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "WKPMessageVCCell.h"
#import "PublicHead.h"
#import "WSChatModel.h"
#import "EMMessage+WKPChatModel.h"
@implementation WKPMessageVCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    WKPLog(@"WKPMessageVCCell  -- awakeFromNib");
    self.num = [[UILabel alloc]init];
    self.num.backgroundColor = BtnBgColor;
    self.num.textColor = [UIColor whiteColor];
    self.num.font = [UIFont systemFontOfSize:13];
    self.num.textAlignment = NSTextAlignmentCenter;
    self.num.layer.masksToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceive:) name:MessageReceive object:nil];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WKPLog(@"WKPMessageVCCell  init");
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCon:(EMConversation *)con{
    _con = con;
    EMMessage* lastMessage = [con  lastReceivedMessage];
    self.username.text =[lastMessage.from substringFromIndex:3];
    WSChatModel* model = [lastMessage model];
    if ([model.chatCellType integerValue] == WSChatCellType_Text) {
        self.message.text = model.content;
    }else if ([model.chatCellType integerValue]==WSChatCellType_Image){
        self.message.text = @"[图片]";
    }else if ([model.chatCellType integerValue]==WSChatCellType_local){
        self.message.text = [NSString stringWithFormat:@"地理位置:%@",model.content];
    }
    [self messageReceive:nil];
    
}

-(void)messageReceive:(NSNotification*)notification{
    EMConversation* con= self.con;
    if(con.unreadMessagesCount ==0){
        [self.num removeFromSuperview];
    }else{
        self.num.text = [NSString stringWithFormat:@"%d",con.unreadMessagesCount];
        [self.num sizeToFit];
        CGFloat numW = [self.num getWidth];
        CGFloat numH = [self.num getHeight];
        if (con.unreadMessagesCount<9) {
            numW = numH;
        }
        if (con.unreadMessagesCount>9) {
            numW = numH+5;
        }
        [self.contentView addSubview:self.num];
        self.num.layer.cornerRadius = numH/2.0;
        CGFloat  y  = [self.contentView getHeight]-numH-5;
        CGFloat  x  = UIWidth- numW-5;
        self.num.frame = CGRectMake(x, y, numW,numH);
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
