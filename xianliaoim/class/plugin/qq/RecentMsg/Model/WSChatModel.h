//
//  WSChatModel.h
//  QQ
//
//  Created by weida on 15/12/21.
//  Copyright © 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "IMTools.h"
#define kCellReuseIDWithSenderAndType(isSender,chatCellType)    ([NSString stringWithFormat:@"%@-%@",isSender,chatCellType])

//根据模型得到可重用Cell的 重用ID
#define kCellReuseID(model)      ((model.chatCellType.integerValue == WSChatCellType_Time)?kTimeCellReusedID:(kCellReuseIDWithSenderAndType(model.isSender,model.chatCellType)))


/**
 *  @brief  消息类型
 */
typedef NS_OPTIONS(NSInteger,WSChatCellType)
{
    /**
     *  @brief  文本消息
     */
    WSChatCellType_Text = 1,
    
    /**
     *  @brief  图片消息
     */
    WSChatCellType_Image = 2,
    
    /**
     *  @brief  语音消息
     */
    WSChatCellType_Audio = 3,
    
    /**
     *  @brief  视频消息
     */
    WSChatCellType_Video = 4,
    
    /**
     *  地理位置
     */
    WSChatCellType_local = 5,
    
    /**
     *  @brief  时间
     */
    WSChatCellType_Time  = 0
};



NS_ASSUME_NONNULL_BEGIN

@interface WSChatModel : NSObject

@property (nullable, nonatomic, strong) NSDate *timeStamp;
@property (nullable, nonatomic, strong) NSNumber *isSender;
@property (nullable, nonatomic, strong) NSNumber *chatCellType;
@property (nullable, nonatomic, strong) NSString *content;
@property (nullable, nonatomic, strong) NSString *headImageURL_sender;
@property (nullable, nonatomic, strong) NSNumber *secondVoice;
@property (nullable, nonatomic, strong) NSNumber *height;
@property (nullable, nonatomic, strong) id sendingImage;

@property(nonatomic,strong)CLLocation* location;
//图片/音频的url地址
@property(nonatomic,strong)NSString* remotePath;
//发送视频时候远程图片的url
//@property(nonatomic,strong)NSString* videoRemotePath;
////纬度
//@property(nonatomic,assign)CGFloat latitude;
////经度
//@property(nonatomic,assign)CGFloat longitude;
////地址
//@property(nonatomic,strong)NSString* address;
@property(nonatomic,assign)BOOL voiceIsPlay;
//原始的message对象
@property(nonatomic,strong)EMMessage* message;
//消息的发送方 名字
@property(nonatomic,strong)NSString* sendName;
@end

NS_ASSUME_NONNULL_END


