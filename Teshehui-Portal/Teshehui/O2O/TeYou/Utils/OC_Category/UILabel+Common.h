//
//  UILabel+Common.h
//  Coding_iOS
//
//  Created by ??? on 14-8-8.
//  Copyright (c) 2014年 ???. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)

- (void) setLongString:(NSString *)str withFitWidth:(CGFloat)width;
- (void) setLongString:(NSString *)str withFitWidth:(CGFloat)width maxHeight:(CGFloat)maxHeight;
- (void) setLongString:(NSString *)str withVariableWidth:(CGFloat)maxWidth;
+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor;
@end
