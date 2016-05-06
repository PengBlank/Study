//
//  HYLoginTextFrameView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-6-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYLoginTextFrameView.h"
#import "UIView+Style.h"

@implementation HYLoginTextFrameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addBorder:1.0 borderColor:[UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1]];
        [self addCorner:5.0];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1].CGColor);
    CGContextMoveToPoint(context, 0, CGRectGetMidY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMidY(rect));
    
    CGContextDrawPath(context, kCGPathStroke);
}


@end
