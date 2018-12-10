//
//  AudioPlayHelper.h
//  KeyBoardView
//
//  Created by joy_yu on 16/3/28.

//

#import <Foundation/Foundation.h>

@interface AudioPlayHelper : NSObject

@property(nonatomic,copy) void(^audioPlayerDidFinishPlaying)(NSString *);

+ (instancetype)helper;



- (void)playAudioWithFileUrl:(NSURL *)url finishPlay:(void(^)(NSString *url))didFinishPlaying;
- (void)pauseAudioWithFileUrl:(NSURL *)url;

@end
