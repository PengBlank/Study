//
//  HYProductFilterView.m
//  Teshehui
//
//  Created by HYZB on 14-9-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYProductFilterView.h"

@implementation HYProductFilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:205.0/255.0 alpha:1.0].CGColor);
    CGContextMoveToPoint(context, 107, 2);
    CGContextAddLineToPoint(context, 107, rect.size.height - 2);
    
    CGContextMoveToPoint(context, 204, 2);
    CGContextAddLineToPoint(context, 204, rect.size.height - 2);
    
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

@end
