//
//  EMMessage+WKPChatModel.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/20.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "EMMessage+WKPChatModel.h"
#import "PublicHead.h"
@implementation EMMessage (WKPChatModel)
-(WSChatModel*)model{
    WSChatModel*  model = [[WSChatModel alloc]init];
    model.message = self;
    model.sendName =self.from;
    NSString* currentName = [EMClient sharedClient].currentUsername;
    if([self.from isEqualToString:currentName]){
        model.isSender = @(YES);
    }else{
        model.isSender = @(NO);
    }
    model.timeStamp = [NSDate dateWithTimeIntervalSince1970:self.timestamp/1000.0];
    EMMessageBody *msgBody = self.body;
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            // 收到的文字消息
            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
            NSString *txt = textBody.text;
//            WKPLog(@"收到的文字是 txt -- %@",txt);
            model.chatCellType = @(WSChatCellType_Text);
            model.content = txt;
        }
            break;
        case EMMessageBodyTypeImage:
        {
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            WKPLog(@"大图remote路径 -- %@"   ,body.remotePath);
            //                NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
            //            NSLog(@"大图的secret -- %@"    ,body.secretKey);
            //                NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
            //                NSLog(@"大图的下载状态 -- %lu",body.downloadStatus);
            
            
            // 缩略图sdk会自动下载
            //                NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
//            WKPLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
            //                NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
            //                NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
            //                NSLog(@"小图的下载状态 -- %lu",body.thumbnailDownloadStatus);
            NSData* imageData=[NSData dataWithContentsOfFile:body.localPath];
            UIImage* image= [UIImage imageWithData:imageData];
            model.sendingImage = image;
            model.remotePath = body.remotePath;
            model.chatCellType = @(WSChatCellType_Image);
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
//            WKPLog(@"纬度-- %f",body.latitude);
//            WKPLog(@"经度-- %f",body.longitude);
//            WKPLog(@"地址-- %@",body.address);
            model.content =body.address;
            model.location = [[CLLocation alloc]initWithLatitude:body.latitude longitude:body.longitude];
            model.chatCellType = @(WSChatCellType_local);
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            // 音频sdk会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
//            WKPLog(@"音频remote路径 -- %@"      ,body.remotePath);
//            WKPLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
//            WKPLog(@"音频的secret -- %@"        ,body.secretKey);
//            WKPLog(@"音频文件大小 -- %lld"       ,body.fileLength);
//            WKPLog(@"音频文件的下载状态 -- %lu"   ,body.downloadStatus);
//            WKPLog(@"音频的时间长度 -- %lu"      ,body.duration);
            NSDictionary* ext = self.ext;
            model.chatCellType = @(WSChatCellType_Audio);
            model.secondVoice = ext[@"time"];
            model.content =body.localPath;
            model.remotePath = body.remotePath;
            
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
            model.chatCellType  = @(WSChatCellType_Video);
            
            NSString* locaPath = body.localPath;
            NSString* pathExtension=[[locaPath pathExtension] uppercaseString];
            WKPLog(@"pathExtension:%@",pathExtension);
            if ([pathExtension  isEqualToString:@"MP4"]) {
                model.content = locaPath;
            }
            
//            model.videoRemotePath =  body.remotePath;
            if([model.isSender boolValue]){
                NSData* imageData=[NSData dataWithContentsOfFile:body.thumbnailLocalPath];
                UIImage* image= [UIImage imageWithData:imageData];
                if(image){
                    model.sendingImage =image;
                }else{
                    model.sendingImage =  [self fristFrameWithVideoUrl:[NSURL fileURLWithPath:body.localPath] withSize:CGSizeMake(300, 300)];
                }
            }else{
                model.remotePath =body.thumbnailRemotePath;
                NSData* imageData=[NSData dataWithContentsOfFile:body.thumbnailLocalPath];
                UIImage* image= [UIImage imageWithData:imageData];
                model.sendingImage =image;
            }
//            
//            WKPLog(@"视频remote路径 -- %@"      ,body.remotePath);
//            WKPLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
//            WKPLog(@"视频的secret -- %@"        ,body.secretKey);
//            WKPLog(@"视频文件大小 -- %lld"       ,body.fileLength);
//            WKPLog(@"视频文件的下载状态 -- %lu"   ,body.downloadStatus);
//            WKPLog(@"视频的时间长度 -- %lu"      ,body.duration);
//            WKPLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
//            
//            // 缩略图sdk会自动下载
//            WKPLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
//            WKPLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
//            WKPLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
//            WKPLog(@"缩略图的下载状态 -- %lu"      ,body.thumbnailDownloadStatus);
            
        }
            break;
        case EMMessageBodyTypeFile:
        {
            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"文件的secret -- %@"        ,body.secretKey);
            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"文件文件的下载状态 -- %lu"   ,body.downloadStatus);
        }
            break;
            
        default:
            break;
    }
    return model;
}

-(NSString*)dateStr{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:self.timestamp/1000];
    NSDateFormatter* df=[[NSDateFormatter alloc]init];
//    df.dateFormat =@"yyyy-MM-dd HH:mm:ss ";
    df.dateFormat = @"MM-dd HH:mm";
    return [df stringFromDate:date];
}

-(UIImage*)fristFrameWithVideoUrl:(NSURL*)url withSize:(CGSize)size{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}
@end
