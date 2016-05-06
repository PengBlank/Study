//
//  UIImage+Addition.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-6-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

- (UIImage *)utilResizableImageWithCapInsets:(UIEdgeInsets)capInsets;
+ (UIImage *)imageWithNamedAutoLayout:(NSString *)name;
//- (UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size;
- (UIImage *)imageWithSize:(CGSize)size;
- (UIImage *)imageWithScaleSize:(CGSize)size;
- (UIImage *)imageWithScaleSize:(CGSize)size radius:(CGFloat)radius;

@end
