//
//  NSString+WKPCategory.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/10.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "NSString+WKPCategory.h"

@implementation NSString (WKPCategory)
-(BOOL)checkTel{
    
    
    NSString* tel= self;
    if (!tel) {
        return NO;
    }
    NSString *phoneRegex = @"^((1[34578]))\\d{9}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(![phoneTest evaluateWithObject:tel]){
        return NO;
    }
    
    return YES;
    
}
@end
