//
//  UIImage+ResizableUtil.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-6-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

- (UIImage *)utilResizableImageWithCapInsets:(UIEdgeInsets)capInsets
{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
    {
        return [self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    } else {
        return [self resizableImageWithCapInsets:capInsets];
    }
}

+ (UIImage *)imageWithNamedAutoLayout:(NSString *)name
{
    if (iPhone6 == currentDeviceType())
    {
        name = [NSString stringWithFormat:@"%@_i6", name];
    }

//    if (iPhone4_4S == currentDeviceType()) {
//        name = [NSString stringWithFormat:@"%@_4s", name];
//    }
    
    return [UIImage imageNamed:name];
}

- (UIImage *)imageWithSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)imageWithScaleSize:(CGSize)size
{
    return [self imageWithScaleSize:size
                             radius:0];
}

- (UIImage *)imageWithScaleSize:(CGSize)size radius:(CGFloat)radius
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //    UIGraphicsBeginImageContext(size);
    
    CGFloat scale = size.width / self.size.width;
    CGFloat hScale = size.height / self.size.height;
    if (hScale < scale) {
        scale = hScale;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width*scale, self.size.height*scale), NO, self.scale);
    
    if (radius > 0)
    {
        // Add a clip before drawing anything, in the shape of an rounded rect
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.size.width*scale, self.size.height*scale)
                                    cornerRadius:radius] addClip];
    }
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, self.size.width*scale, self.size.height*scale)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
