//
//  HYHotelPointView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelPointView.h"

@implementation HYHotelPointView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:193.0f/255.0f
                                               green:193.0f/255.0f
                                                blue:193.0f/255.0f
                                               alpha:1.0f];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGFloat width = (rect.size.width * self.currentPoint/self.maxPoint);
    
    CGRect fillRect = CGRectMake(0, 0, width, rect.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext() ;
	
    UIColor *fillColor = [UIColor colorWithRed:23.0f/255.0f
                                         green:124.0f/255.0f
                                          blue:184.0f/255.0f
                                         alpha:1.0f];
	// save the context
	CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);//填充色设置成灰色
    CGContextFillRect(context,fillRect);//把整个空间用刚设置的颜色填充
    CGContextStrokePath(context);//把线在界面上绘制出来
    CGContextRestoreGState(context);
}

- (void)setCurrentPoint:(CGFloat)currentPoint
{
    if (currentPoint != _currentPoint)
    {
        _currentPoint = currentPoint;
        [self setNeedsDisplay];
    }
}
@end

