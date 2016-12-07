//
//  NSArray+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

+ (BOOL)isAvailable:(NSArray *)aArray {
    
    if (aArray && ![aArray isKindOfClass:NSNull.class] && aArray.count > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *description = [NSMutableString string];
    
    [description appendString:@"[\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [description appendFormat:@"%@,\n", obj];
    }];
    
    [description appendString:@"]"];
    
    // 查出最后一个','的范围
    NSRange range = [description rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个','
        [description deleteCharactersInRange:range];
    }
    
    return description;
}

@end
