//
//  HYSummaryCellBgView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-6-17.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSummaryCellBgView.h"

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius) {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    return path;        
}

@implementation HYSummaryCellBgView

@synthesize styleColor = _styleColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setNumberOfRow:(NSInteger)numberOfRow
{
    _numberOfRow = numberOfRow;
    
    [self setNeedsDisplay];
}

- (UIColor *)styleColor
{
    if (!_styleColor) {
        _styleColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    }
    return _styleColor;
}

- (void)setStyleColor:(UIColor *)styleColor
{
    if (_styleColor != styleColor) {
        _styleColor = styleColor;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat x = 20;
    rect.origin.x += x;
    rect.size.width -= 2 * x;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //圆角背景
    CGMutablePathRef roundedrect = createRoundedRectForRect(rect, 10);
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, self.styleColor.CGColor);
    CGContextAddPath(context, roundedrect);
    CGContextFillPath(context);
    CGPathRelease(roundedrect);
    CGContextRestoreGState(context);
    
    if (_numberOfRow > 1)
    {
        CGFloat each = CGRectGetHeight(rect) / _numberOfRow;
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor);
        //CGFloat w = CGRectGetWidth(rect);
        CGFloat x = CGRectGetMinX(rect) + 10;
        CGFloat xto = CGRectGetWidth(self.frame) - 20 - 10;
        for (int i = 1; i < _numberOfRow; i++) {
            CGContextMoveToPoint(context, x, each * i);
            CGContextAddLineToPoint(context, xto, each * i);
        }
    }
    
    
    
    
    CGContextStrokePath(context);
}


@end
