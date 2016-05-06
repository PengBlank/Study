//
//  LineView.h
//  YYHealth
//
//  Created by xkun on 15/6/10.
//  Copyright (c) 2015年 xkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIImageView

/////////////////////////////////////////////////画水平线
- (id)initWithFrame:(CGRect)frame color:(UIColor*)color;

/////////////////////////////////////////////////选择画平线
- (id)initWithFrame:(CGRect)frame color:(UIColor*)color vertical:(BOOL)isVertical;

/**
 *  @brief  贴图显示一像素灰色线段，实际是两像素，一像素透明，一像素特定灰色
 *
 *  @param isVertical       是否是一像素竖线
 *  @param isFirstOpaque    是否第一像素不透明
 */
- (id)initGrayLineWithFrame:(CGRect)frame
                   vertical:(BOOL)isVertical
         isFirstPixelOpaque:(BOOL)isFirstOpaque;


/**
 *  @brief  贴图显示一像素指定颜色线段，实际是两像素，一像素透明，一像素指定颜色
 *
 *  @param isVertical       是否是一像素竖线
 *  @param isFirstOpaque    是否第一像素不透明
 *  @param color            一像素线颜色
 */
- (id)initWithFrame:(CGRect)frame
           vertical:(BOOL)isVertical
 isFirstPixelOpaque:(BOOL)isFirstOpaque
          lineColor:(UIColor *)color;


@end
