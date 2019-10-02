//
//  NSString+WKPPNGString.m
//  xianliaoim
//
//  Created by wangkang on 2018/12/21.
//  Copyright © 2018 wangkang. All rights reserved.
//

#import "NSString+WKPPNGString.h"
#import "PublicHead.h"
@implementation NSString (WKPPNGString)
-(NSAttributedString*)pngStr{
    
    NSMutableAttributedString* astr=[[NSMutableAttributedString alloc]initWithString:self];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineSpacing = 10;
    [astr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    for (NSInteger i=1; i<142; i++) {
        NSString* key=nil;
        if (i<10) {
            key = [NSString stringWithFormat:@"00%ld",i];
        }else if (i<100){
            key = [NSString stringWithFormat:@"0%ld",i];
        }else{
            key = [NSString stringWithFormat:@"%ld",i];
        }
        NSString* keyStr=[NSString stringWithFormat:@"[%@]",key];
//        WKPLog(@"1.astr:%@",[astr string]);
        NSRange range = [[astr string] rangeOfString:keyStr];
        while(range.location !=NSNotFound) {
            [astr deleteCharactersInRange:range];
            NSTextAttachment* attch =[[NSTextAttachment alloc]init];
            attch.image = [UIImage imageNamed:key];
//            attch.bounds=CGRectMake(0, 0, 15, 15);
            attch.bounds = CGRectMake(0, 0, 28, 28);
            NSAttributedString* imageStr=[NSAttributedString attributedStringWithAttachment:attch];
            [astr insertAttributedString:imageStr atIndex:range.location];
//            WKPLog(@"2.astr:%@",[astr string]);
            range= [[astr string] rangeOfString:keyStr];
           
        }
    }
    
    return  astr;
}
@end
