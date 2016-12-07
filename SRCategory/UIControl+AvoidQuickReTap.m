//
//  UIControl+AvoidQuickReTap.m
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UIControl+AvoidQuickReTap.h"
#import <objc/runtime.h>

@interface UIControl ()

@property (nonatomic, assign) BOOL ignoreEvent;

@end

@implementation UIControl (AvoidQuickReTap)

static const void *AcceptEventTimeIntervalKey = &AcceptEventTimeIntervalKey;

- (NSTimeInterval)acceptEventTimeInterval {
    
    return [objc_getAssociatedObject(self, AcceptEventTimeIntervalKey) doubleValue];
}

- (void)setAcceptEventTimeInterval:(NSTimeInterval)acceptEventTimeInterval {
    
    objc_setAssociatedObject(self, AcceptEventTimeIntervalKey, @(acceptEventTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *IgnoreEventKey = &IgnoreEventKey;

- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    
    objc_setAssociatedObject(self, IgnoreEventKey, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEvent {
    
    return [objc_getAssociatedObject(self, IgnoreEventKey) boolValue];
}

+ (void)load {
    
    Method oldImp = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method newImp = class_getInstanceMethod(self, @selector(hookSendAction:to:forEvent:));
    method_exchangeImplementations(oldImp, newImp);
}

- (void)hookSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.ignoreEvent) {
        return;
    }
    
    if (self.acceptEventTimeInterval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(resetIgnoreEvent) withObject:@(NO) afterDelay:self.acceptEventTimeInterval];
    }
    
    [self hookSendAction:action to:target forEvent:event];
}

- (void)resetIgnoreEvent {
    
    self.ignoreEvent = NO;
}

@end
