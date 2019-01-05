//
//  IMTools.h
//  xianliaoim
//
//  Created by wangkang on 2018/11/27.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Hyphenate/Hyphenate.h>
#import "RequestModel.h"
#import "RemarkModel.h"

#define MessageReceive   @"messageReceive"
#define MessageWSModel   @"messageModel"
#define Message          @"message"


#define MessageCallSession @"callSession"
#define MessageCallVC      @"callVC"

#define MessageUnRead        @"unRead"
#define MessageUnReadCount   @"unReadCount"
NS_ASSUME_NONNULL_BEGIN
typedef void(^IMToolsBlock)(id  obj,EMError* error);
@interface IMTools : NSObject
+(instancetype)defaultInstance;

//初始化IM
-(void)setUpIM:(NSDictionary*)launchOptions;

//注册
//-( EMError* __nullable )registerWithUserName:(NSString*)username withPassWord:(NSString*)passWord;
//登入
//-( EMError* __nullable )loginWithName:(NSString*)name withPassWord:(NSString*)passWord;

//发送文本消息
-(void)sendMessageWithText:(NSString*)text withUser:(NSString*)userName withConversationID:(NSString*)conversationId withBlock:(IMToolsBlock)block;
//发送图片消息
-(void)sendMessageWithUIImage:(UIImage*)image withUser:(NSString*)userName withConversationID:(NSString*)conversationId withBlock:(IMToolsBlock)block;
//发送地理位置
-(void)sendMessageWithLatitude:(CGFloat)latitude withLongitude:(CGFloat)longitude withAddress:(NSString*)address withUser:(NSString*)userName withConversationID:(NSString*)conversationId
    withBlock:(IMToolsBlock)block;
//发送语音消息
-(void)seedMessageWithVoiceLocalPath:(NSString*)localPath withDisplayName:(NSString*)name withUser:(NSString*)userName withConversationID:(NSString*)conversationId withInfo:(NSDictionary*)ext withBlock:(IMToolsBlock)block;
//发送视频消息
-(void)seedMessageWithVideoLocalPath:(NSString*)localPath withDisplayName:(NSString*)name withUser:(NSString*)userName withConversationID:(NSString*)conversationId withBlock:(IMToolsBlock)block;
//新建一个会话 1v1
-(EMConversation*)createConversationWithUser:(NSString*)userName;
//删除多个会话
-(void)deleteConversation:(NSArray*)array withBlock:(IMToolsBlock)block;
//获取所有会话
-(NSArray*)getAllConversation;

//获取所有好友
-(NSArray*)getAllContacts;
//发送好友请求
-(EMError*)addContaceRequest:(NSString*)username withMessage:(NSString*)message;
//获取请求加好友的被请求数组
-(NSArray*)getAllRequest;
//删除好友
-(EMError*)deleteContact:(NSString*)userName;
//同意加好友
-(EMError*)acceptRequest:(RequestModel*)requestModel;
//拒接好友请求
-(EMError*)declineInvitationForUsername:(RequestModel*)requestModel;

//发起音频call
-(void)sendAudioCall:(NSString*)aUsername;
//发起视频call
-(void)sendVideoCall:(NSString*)aUsername;

//插入一个备注
-(void)insertRemarkModel:(RemarkModel*)model;
//修改备注
-(void)updateRemarkName:(NSString*)remarkName withName:(NSString*)name;
//找个备注
-(RemarkModel*)queryRemarkNameByName:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
