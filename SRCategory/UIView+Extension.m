//
//  UIView+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/11/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (UIViewController *)viewControllerResponder {
    
    id responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width {
    
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:color.CGColor];
}

- (void)setCornerRadius:(CGFloat)radius {
    
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
}

- (void)setShadowColor:(UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius {
    
    [self.layer setShadowColor:color.CGColor];
    [self.layer setShadowOpacity:opacity];
    [self.layer setShadowOffset:offset];
    [self.layer setShadowRadius:blurRadius];
}

@end
