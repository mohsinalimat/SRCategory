//
//  NSDictionary+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *description = [NSMutableString string];
    
    [description appendString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [description appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [description appendString:@"}"];
    
    // 查出最后一个','的范围
    NSRange range = [description rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个','
        [description deleteCharactersInRange:range];
    }
    
    return description;
}

@end
