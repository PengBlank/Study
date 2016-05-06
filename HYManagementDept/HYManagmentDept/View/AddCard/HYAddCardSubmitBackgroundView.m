//
//  HYAddCardSubmitBackgroundView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-27.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAddCardSubmitBackgroundView.h"

@implementation HYAddCardSubmitBackgroundView

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
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(c, 163/255.0, 163/255.0, 163/255.0, 1);
//    CGContextSetRGBFillColor(c, 190/255.0, 190/255.0, 190/255.0, 1);
//    
//    CGContextMoveToPoint(c, 0, 0);
//    CGContextAddLineToPoint(c, CGRectGetWidth(rect), 0);
//    CGContextMoveToPoint(c, 0, CGRectGetHeight(rect));
//    CGContextAddLineToPoint(c, CGRectGetWidth(rect), CGRectGetHeight(rect));
//    
//    CGContextFillRect(c, CGRectMake(0, 1, CGRectGetWidth(rect), CGRectGetHeight(rect)-2));
//    
//    CGContextStrokePath(c);
//}


@end
