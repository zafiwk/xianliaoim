//
//  VoiceRecordHelper.h
//  KeyBoardView
//
//  Created by joy_yu on 16/3/20.

//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef BOOL(^PrepareRecorderCompletion)(void);
typedef void(^StartRecorderCompletion)(void);
typedef void(^StopRecorderCompletion)(NSString *);
typedef void(^PauseRecorderCompletion)(void);
typedef void(^ResumeRecorderCompletion)(void);
typedef void(^CancellRecorderDeleteFileCompletion)(void);
typedef void(^RecordProgress)(float progress);
typedef void(^PeakPowerForChannel)(float peakPowerForChannel);


@interface VoiceRecordHelper : NSObject

@property (nonatomic, copy) StopRecorderCompletion maxTimeStopRecorderCompletion;
@property (nonatomic, copy) StopRecorderCompletion minTimeStopRecorderCompletion;
@property (nonatomic, copy) RecordProgress recordProgress;
@property (nonatomic, copy) PeakPowerForChannel peakPowerForChannel;
@property (nonatomic, copy, readonly) NSString *recordPath;
@property (nonatomic, copy) NSString *recordDuration;
@property (nonatomic) float maxRecordTime; // 默认 120秒为最大
@property (nonatomic) float minRecordTime; // 默认 3秒为最小
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(PrepareRecorderCompletion)prepareRecorderCompletion;
- (void)startRecordingWithStartRecorderCompletion:(StartRecorderCompletion)startRecorderCompletion;
- (void)pauseRecordingWithPauseRecorderCompletion:(PauseRecorderCompletion)pauseRecorderCompletion;
- (void)resumeRecordingWithResumeRecorderCompletion:(ResumeRecorderCompletion)resumeRecorderCompletion;
- (void)stopRecordingWithStopRecorderCompletion:(StopRecorderCompletion)stopRecorderCompletion;
- (void)cancelledDeleteWithCompletion:(CancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;

@end
