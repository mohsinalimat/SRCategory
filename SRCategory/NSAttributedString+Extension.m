//
//  NSAttributedString+Extension.m
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)

+ (NSAttributedString *)attributedStringWithString:(NSString *)string
                                       shadowColor:(UIColor *)shadowColor
                                  shadowBlurRadius:(CGFloat)shadowBlurRadius
                                      shadowOffset:(CGSize)shadowOffset
{
    if (!string) {
        return nil;
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSShadow *shadow                  = [[NSShadow alloc] init];
    shadow.shadowColor                = shadowColor;
    shadow.shadowBlurRadius           = shadowBlurRadius;
    shadow.shadowOffset               = shadowOffset;
    [attStr addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, string.length)];
    return attStr;
}

@end
