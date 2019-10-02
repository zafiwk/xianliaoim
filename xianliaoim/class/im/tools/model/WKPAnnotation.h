//
//  WKPAnnotation.h
//  xianliaoim
//
//  Created by wangkang on 2018/12/17.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKPAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
// Title and subtitle for use by selection UI.
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@end

NS_ASSUME_NONNULL_END
