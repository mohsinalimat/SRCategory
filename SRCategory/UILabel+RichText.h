//
//  UILabel+RichText.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RichText)

/** The text row spacing */
@property (nonatomic, assign) CGFloat  characterLineSpace;
/** The text column spacing  */
@property (nonatomic, assign) CGFloat  characterColumnSpace;

/** The text keyword */
@property (nonatomic, copy  ) NSString *keywords;
/** The keyword font */
@property (nonatomic, strong) UIFont   *keywordsFont;
/** The keyword color */
@property (nonatomic, strong) UIColor  *keywordsColor;

/** The text underline */
@property (nonatomic, copy  ) NSString *underlineString;
/** The underline color */
@property (nonatomic, strong) UIColor  *underlineColor;

/**
 Apply rich effect
 */
- (void)applyRichEffect;

/**
 According to the maximum width calculating the Size of the Label

 @param maxWidth maximum width
 @return the Size of the Label
 */
- (CGSize)getRectWithMaxWidth:(CGFloat)maxWidth;

@end
