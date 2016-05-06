//
//  UIDevice+Resolutions.h
//  DaXueBao
//
//  Created by RayXiang on 14-4-29.
//  Copyright (c) 2014年 souvi. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            = 2,
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes      = 3,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 4,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5
}; typedef NSUInteger UIDeviceResolution;

@interface UIDevice (Resolutions)

/**
 *  获取当前分辨率
 *
 *  @return resolution.
 */
+ (UIDeviceResolution) currentResolution;

/**
 *  是否运行在iPhone5端
 *
 *  @return Yes or not
 */
+ (BOOL)isRunningOniPhone5;

/**
 *  是否运行在iphone4客户端
 *
 *  @return yes or not.
 */
+ (BOOL)isRunningOniPhone4;

/**
 *  是否运行在iphone客户端
 *
 *  @return yes or not.
 */
+ (BOOL)isRunningOniPhone;

+ (BOOL)isRunningOnPad;

@end
