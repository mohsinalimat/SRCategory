//
//  UIImage+Extension.h
//  SRCategories
//
//  Created by 郭伟林 on 16/11/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (instancetype)imageFromColor:(UIColor *)color;

+ (instancetype)imageFromLayer:(CALayer *)layer;

+ (instancetype)videoFirstImageWithVideoPath:(NSString *)videoPath;

+ (instancetype)circleImageWithImage:(UIImage *)originalImage borderWidth:(NSInteger)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)resizeImage:(UIImage *)originalImage toSize:(CGSize)dstSize;
+ (instancetype)resizeImage:(UIImage *)originalImage toW:(CGFloat)dstW;

- (instancetype)resizeImageToSize:(CGSize)dstSize;

- (instancetype)subImageInRect:(CGRect)rect;

- (NSData *)imageCompressedToMost32KData;
+ (NSData *)wxShareThumbnail:(UIImage *)thumbImage;

@end
