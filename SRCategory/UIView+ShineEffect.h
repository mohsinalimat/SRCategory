//
//  UIView+ShineEffect.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShineEffect)

/**
 *  定时器的时间间隔
 */
@property (nonatomic, strong) NSNumber *GCDTimerInterval;
/**
 *  动画的周期
 */
@property (nonatomic, strong) NSNumber *shineDuration;
/**
 *  动画的透明度[0~1]
 */
@property (nonatomic, strong) NSNumber *shineLayerOpacity;


/**
 *  创建shineLaßyer
 *
 *  @param color  layer的颜色
 *  @param radius layer的模糊度
 */
- (void)createShineLayerWithColor:(UIColor *)color radius:(CGFloat)radius;

/**
 *  无限循环闪烁
 */
- (void)shineLayerLoop;

- (void)shineLayerHiddenToShow;

- (void)shineLayerShowToHidden;

@end
