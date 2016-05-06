//
//  UIUtils.h
//  YYHealth
//
//  Created by xkun on 15/6/10.
//  Copyright (c) 2015年 xkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//UIColor *colorWithHex(long hexColor);
//UIColor *colorWithHexAndAlpha(long hexColor, float opacity);

@interface UIUtils : NSObject

+ (BOOL)iPhone6Puls;
+ (BOOL)iPhone6;
+ (BOOL)iPhone5;
+ (BOOL)isPad;
+ (UIColor *)getColor:(NSString *)hexColor;
+ (NSString *)getVersion;
+ (NSString *)timestamp;


//字符串转码成UTF-8
+ (NSString *)stringToUTF8:(NSString *)string;


+ (UIView *) addLineInView:(UIView *)parentView
                       top:(BOOL)isTop
                leftMargin:(CGFloat)leftMargin
               rightMargin:(CGFloat)rightMargin;

+ (UIView *) addLineInView:(UIView *)parentView
                       top:(BOOL)isTop
                     color:(NSString *)color
                leftMargin:(CGFloat)leftMargin
               rightMargin:(CGFloat)rightMargin;

/**
 *  生成用于拉伸的UIImage图 (2x1 Or 1*2)像素永久保存内存
 *
 *  @param isVertical      是否垂直拉伸
 *  @param isFirstOpaque   是否第一像素不透明
 *  @param highlightColor  显示的颜色
 *	@param isHighlightLeft 颜色是否显示在左边(横向拉伸时，是否现在在上面)
 *
 *  @return image
 */
+ (UIImage *)getLineImageWithIsVertical:(BOOL)isVertical
                     isFirstPixelOpaque:(BOOL)isFirstOpaque
                         highlightColor:(UIColor *)highlightColor;
/**
 *  获取圆角蒙版Image 永久保存内存
 *
 *  @param size   大小
 *  @param radius 圆角
 *  @param color  蒙版颜色
 *
 *  @return Image
 */
+ (UIImage *)getRoundImageWithCutOuter:(BOOL)isCutOuter
                                  Size:(CGSize)size
                                Radius:(CGFloat)radius
                                 color:(UIColor *)color
                       withStrokeColor:(UIColor *)strokeColor;



@end

