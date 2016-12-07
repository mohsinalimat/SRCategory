//
//  UIView+Extension.h
//  SRCategories
//
//  Created by 郭伟林 on 16/11/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

- (UIViewController *)viewControllerResponder;

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width;
- (void)setCornerRadius:(CGFloat)radius;
- (void)setShadowColor:(UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius;

@end
