//
//  UIImage+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/11/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UIImage+Extension.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Extension)

+ (UIImage *)imageFromColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)imageFromLayer:(CALayer *)layer {
    
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)videoFirstImageWithVideoPath:(NSString *)videoPath {
    
    if (!videoPath || videoPath.length == 0) {
        return nil;
    }
    AVURLAsset *urlAsset                               = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    AVAssetImageGenerator *assetImageGenerator         = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.requestedTimeToleranceBefore   = kCMTimeZero;
    assetImageGenerator.requestedTimeToleranceAfter    = kCMTimeZero;
    CMTime time         = CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC);
    CGImageRef imageRef = [assetImageGenerator copyCGImageAtTime:time actualTime:NULL error:nil];
    if (imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        return image;
    } else {
        return nil;
    }
}

// 注意: 不要使用此种方式剪切圆形图片, 会造成卡顿, 反而不如直接使用 layer.cornerRadius layer.masksToBounds.
+ (instancetype)circleImageWithImage:(UIImage *)originalImage borderWidth:(NSInteger)borderWidth borderColor:(UIColor *)borderColor {
    
    CGSize size = CGSizeMake(originalImage.size.width + borderWidth, originalImage.size.height + borderWidth);
    
    // 创建图形上下文, YES 不透明; NO 透明.
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // 取得图片上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 大圆
    CGContextAddEllipseInRect(contextRef, CGRectMake(0, 0, size.width, size.height));
    [borderColor set];
    // 绘制大圆
    CGContextFillPath(contextRef);
    
    // 小圆
    CGFloat smallX = borderWidth * 0.5;
    CGFloat smallY = borderWidth * 0.5;
    CGFloat smallW = originalImage.size.width;
    CGFloat smallH = originalImage.size.height;
    CGContextAddEllipseInRect(contextRef, CGRectMake(smallX, smallY, smallW, smallH));
    [[UIColor greenColor] set];
    
    // 绘制小圆, As a side effect when you call this function, Quartz clears the current path.
    // CGContextFillPath(ctx);
    
    // 指定小圆范围, Modifies the current clipping path, 已经绘制的内容不受影响, After determining the new clipping path, the function resets the context’s current path to an empty path.
    CGContextClip(contextRef);
    
    // 绘制图片, 超出小圆部分会被剪切.
    [originalImage drawInRect:CGRectMake(smallX, smallY, smallW, smallH)];
    
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}

+ (instancetype)resizeImage:(UIImage *)originalImage toSize:(CGSize)dstSize {
    
    UIImage *newImage = nil;
    
    CGSize  imageSize      = originalImage.size;
    CGFloat width          = imageSize.width;
    CGFloat height         = imageSize.height;
    CGFloat targetWidth    = dstSize.width;
    CGFloat targetHeight   = dstSize.height;
    CGFloat scaleFactor    = 0.0;
    CGFloat scaledWidth    = targetWidth;
    CGFloat scaledHeight   = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, dstSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(dstSize);
    
    CGRect thumbnailRect      = CGRectZero;
    thumbnailRect.origin      = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [originalImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (newImage == nil) {
        NSLog(@"scale image failed");
    }
    return newImage;
}


+ (instancetype)resizeImage:(UIImage *)originalImage toW:(CGFloat)dstW {
    
    UIImage *newImage = nil;
    
    CGSize  imageSize      = originalImage.size;
    CGFloat width          = imageSize.width;
    CGFloat height         = imageSize.height;
    CGFloat targetHeight   = height / (width / dstW);
    
    CGSize  size           = CGSizeMake(dstW, targetHeight);
    CGFloat scaleFactor    = 0.0;
    CGFloat scaledWidth    = dstW;
    CGFloat scaledHeight   = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = dstW / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if(widthFactor < heightFactor) {
            thumbnailPoint.x = (dstW - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect      = CGRectZero;
    thumbnailRect.origin      = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [originalImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (newImage == nil) {
        NSLog(@"scale image failed");
    }
    return newImage;
}

- (UIImage*)resizeImageToSize:(CGSize)dstSize {
    
    CGImageRef imgRef = self.CGImage;
    // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
    CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
    /* Don't resize if we already meet the required destination size. */
    if (CGSizeEqualToSize(srcSize, dstSize)) {
        return self;
    }
    CGFloat scaleRatio = dstSize.width / srcSize.width;
    UIImageOrientation orient = self.imageOrientation;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch(orient) {
            
        case UIImageOrientationUp:            //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:    //EXIF = 2
            transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:          //EXIF = 3
            transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:  //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:  //EXIF = 5
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationLeft:          //EXIF = 6
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:         //EXIF = 8
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    // The actual resize: draw the image on a new context, applying a transform matrix
    UIGraphicsBeginImageContextWithOptions(dstSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -srcSize.height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -srcSize.height);
    }
    CGContextConcatCTM(context, transform);
    
    // we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (instancetype)subImageInRect:(CGRect)rect {
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CFRelease(subImageRef);
    return smallImage;
}

- (NSData *)imageCompressedToMost32KData {
    
    static CGFloat kMaxImageDataLength = 32 * 1024.0;
    
    CGFloat quality = 1.0;
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    NSUInteger dataLength = data.length;
    if (dataLength > kMaxImageDataLength) {
        quality = 1.0 - kMaxImageDataLength / dataLength;
    }
    return UIImageJPEGRepresentation(self, quality);
}

+ (NSData *)wxShareThumbnail:(UIImage *)thumbImage {
    
    static CGFloat kMaxImageDataLength = 32 * 1024.0;
    NSData *thumbData = UIImageJPEGRepresentation(thumbImage, 0.9);
    BOOL flag = thumbData.length > kMaxImageDataLength;
    while (flag) {
        thumbImage = [thumbImage resizeImageToSize:CGSizeMake(thumbImage.size.width * 0.9, thumbImage.size.height * 0.9)];
        thumbData = UIImageJPEGRepresentation(thumbImage, 0.9);
        flag = thumbData.length > kMaxImageDataLength;
    }
    return thumbData;
}

@end
