//
//  IMTools.m
//  xianliaoim
//
//  Created by wangkang on 2018/11/27.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "IMTools.h"
#import <FMDB/FMDB.h>
#import "PublicHead.h"
#import "WSChatModel.h"
#import "EMMessage+WKPChatModel.h"
@interface IMTools()<EMChatManagerDelegate,EMContactManagerDelegate,EMClientDelegate>
@property(nonatomic,strong)FMDatabase* dataBase;
@end

static IMTools* tools;
@implementation IMTools
+(instancetype)defaultInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools=[[IMTools alloc]init];
    });
    
    return tools;
}
//alloc 默认就是调用这个方法处于历史遗留问题 保留
+(id)allocWithZone:(struct  _NSZone *)zone{
    if(!tools){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tools = [super allocWithZone:zone];
        });
    }
    return tools;
}

-(id)copyWithZone:(struct _NSZone*)zone{
    return [IMTools defaultInstance];
}

//初始化IM
-(void)setUpIM:(NSDictionary*)launchOptions{
    EMOptions* options = [EMOptions optionsWithAppkey:@"wkdlose#wkp-xianliao"];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient]initializeSDKWithOptions:options];
    
    //注册消息的接受
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    //监听好友请求
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    NSString* docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* dbPath=[NSString stringWithFormat:@"%@/%@",docPath,@"contact.db"];
    self.dataBase=[[FMDatabase alloc]initWithPath:dbPath];
    if([self.dataBase open]){
        [self.dataBase executeUpdate:@"\
         create table  if not exists contact(\
         id integer primary key autoincrement,\
         name text,\
         message text)"];
    }
    
    //初始化获取一次好友列表
    [self  getAllContacts];
}
//注册
//-(EMError*)registerWithUserName:(NSString*)username withPassWord:(NSString*)passWord{
//    EMError* error=[[EMClient sharedClient] registerWithUsername:username password:passWord];
//    return error;
//}
//登入
//-(EMError*)loginWithName:(NSString*)name withPassWord:(NSString*)passWord{
//    EMError* error=[[EMClient sharedClient]loginWithUsername:name token:passWord];
//    return error;
//}
-(NSString*)curentUsername{
    NSString* from = [[EMClient sharedClient] currentUsername];
    return  from;
}
-(void)sendMessageWithEMMessage:(EMMessage*)message withBlock:(IMToolsBlock)block{
    message.chatType=EMChatTypeChat;
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        
        WKPLog(@"消息发送回调");
        WKPLog(@"error:%@",error?error.description:@"");
        if (block) {
            block(message,error);
        }
    }];
}
//发送文本消息
-(void)sendMessageWithText:(NSString*)text withUser:(NSString*)userName withConversationID:(NSString*)conversationId withBlock:(IMToolsBlock)block{
    EMTextMessageBody* body=[[EMTextMessageBody alloc]initWithText:text];
    EMMessage* mesage=[[EMMessage alloc]initWithConversationID:conversationId from:[self curentUsername] to:userName body:body ext:nil];
    [self sendMessageWithEMMessage:mesage withBlock:block];
    
}
//发送图片消息
-(void)sendMessageWithUIImage:(UIImage*)image withUser:(NSString*)userName withConversationID:(NSString*)conversationId withBlock:(IMToolsBlock)block{
    EMImageMessageBody* body=[[EMImageMessageBody alloc]initWithData:UIImagePNGRepresentation(image) displayName:userName];
    EMMessage* message = [[EMMessage alloc]initWithConversationID:conversationId from:[self curentUsername] to:userName body:body ext:nil];
    [self sendMessageWithEMMessage:message withBlock:block];
}
//发送地理位置
-(void)sendMessageWithLatitude:(CGFloat)latitude withLongitude:(CGFloat)longitude withAddress:(NSString*)address withUser:(NSString*)userName withConversationID:(NSString*)conversationId
    withBlock:(IMToolsBlock)block{
    EMLocationMessageBody* body=[[EMLocationMessageBody alloc]initWithLatitude:latitude longitude:longitude address:address];
    EMMessage* message=[[EMMessage alloc]initWithConversationID:conversationId from:[self curentUsername] to:userName body:body ext:nil];
    [self sendMessageWithEMMessage:message withBlock:block];
}
//发送语音消息
-(void)seedMessageWithVoiceLocalPath:(NSString*)localPath withDisplayName:(NSString*)name withUser:(NSString*)userName withConversationID:(NSString*)conversationId withBlock:(IMToolsBlock)block{
    EMVoiceMessageBody* body=[[EMVoiceMessageBody alloc]initWithLocalPath:localPath displayName:name];
    EMMessage* message=[[EMMessage alloc]initWithConversationID:conversationId from:[self  curentUsername] to:userName body:body ext:nil];
    [self sendMessageWithEMMessage:message withBlock:block];
}
//发送视频消息
-(void)seedMessageWithVideoLocalPath:(NSString*)localPath withDisplayName:(NSString*)name withUser:(NSString*)userName withConversationID:(NSString*)conversationId withBlock:(IMToolsBlock)block{
    EMVideoMessageBody* body=[[EMVideoMessageBody alloc]initWithLocalPath:localPath displayName:name];
    EMMessage* message=[[EMMessage alloc]initWithConversationID:conversationId from:[self  curentUsername] to:userName body:body ext:nil];
    [self sendMessageWithEMMessage:message withBlock:block];
}
#pragma mark 会话相关
//新建一个会话 1v1
-(EMConversation*)createConversationWithUser:(NSString*)userName{
  return [[EMClient sharedClient].chatManager getConversation:userName type:EMConversationTypeChat createIfNotExist:YES];
}
//删除多个会话
-(void)deleteConversation:(NSArray*)array withBlock:(IMToolsBlock)block{
    [[EMClient sharedClient].chatManager deleteConversations:array isDeleteMessages:YES completion:^(EMError *aError) {
        block(nil,aError);
    }];
}
//获取所有会话
-(NSArray*)getAllConversation{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    return conversations;
}

#pragma mark EMChatManagerDelegate
-(void)messagesDidReceive:(NSArray *)aMessages{
    for (EMMessage *message in aMessages) {
        WSChatModel* model =[message model];
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageReceive object:nil userInfo:@{MessageWSModel:model,Message:message}];
      
    }
    
  
}

#pragma mark EMContactManagerDelegate

/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    [self saveRequestLocal:aUsername withMessage:aMessage];
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
    
}
#pragma mark 好友相关
-(void)saveRequestLocal:(NSString*)username withMessage:(NSString*)message{
    NSString* insertSql = [NSString stringWithFormat:@"insert into contact(name,message)  values('%@','%@')",username,message];
    [self.dataBase executeUpdate:insertSql];
}
-(NSMutableArray*)queryAllRequest{
    NSString* selectSql=@"SELECT * FROM contact order by id desc";
    FMResultSet* resultSet = [self.dataBase executeQuery:selectSql];
    NSMutableArray* dataArray=[NSMutableArray array];
    while([resultSet next]){
        RequestModel* model=[[RequestModel alloc]init];
        model.keyId = [resultSet intForColumn:@"id"];
        model.username = [resultSet stringForColumn:@"name"];
        model.message = [resultSet stringForColumn:@"message"];
        [dataArray addObject:model];
    }
    
    return dataArray;
}

-(void)deleteRequestByKeyId:(NSInteger)keyId{
    NSString* deleteSql=[NSString stringWithFormat:@"delete from contact where id=%ld",keyId];
    [self.dataBase executeUpdate:deleteSql];
}
//获取所有好友
-(NSArray*)getAllContacts{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //网络请求
        EMError* error=nil;
        [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
          if (error) {
            NSLog(@"获取朋友列表成功");
        }
    });
    //本地数据库拉去
    return [[EMClient sharedClient].contactManager getContacts];
 
}
//发送好友请求
-(EMError*)addContaceRequest:(NSString*)username withMessage:(NSString*)message{
    EMError* error =[[EMClient sharedClient].contactManager addContact:username message:message];
    return error;
}
//获取请求加好友的被请求数组
-(NSArray*)getAllRequest{
    return  [self queryAllRequest];
}
//删除好友
-(EMError*)deleteContact:(NSString*)userName{
    EMError* error=[[EMClient sharedClient].contactManager deleteContact:userName isDeleteConversation:YES];
    return error;
}
//同意加好友
-(EMError*)acceptRequest:(RequestModel*)requestModel{
    EMError* error=[[EMClient sharedClient].contactManager acceptInvitationForUsername:requestModel.username];
    [self deleteRequestByKeyId:requestModel.keyId];
    return error;
}
//拒接好友请求
-(EMError*)declineInvitationForUsername:(RequestModel*)requestModel{
    EMError* error=[[EMClient sharedClient].contactManager declineInvitationForUsername:requestModel.username];
    [self deleteRequestByKeyId:requestModel.keyId];
    return error;
}
- (void)autoLoginDidCompleteWithError:(EMError *)error{
    WKPLog(@"自动登入error:%@",error);
}
- (void)userDidForbidByServer{
    WKPLog(@"服务被禁用");
}

#pragma mark 群管理
@end
