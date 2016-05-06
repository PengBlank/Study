//
//  UIColor+hexColor.h
//  Putao
//
//  Created by 程 谦 on 12-6-18.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

/**
 * UIColor扩展方法
 */

#import <UIKit/UIKit.h>

@interface UIColor (hexColor)

+ (UIColor *)colorWithHexColor:(NSString *)hexColor alpha:(CGFloat)alpha;
@end
