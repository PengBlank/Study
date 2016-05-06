//
//  HYMallSectionView.m
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallSectionView.h"
#import "UIColor+hexColor.h"

@implementation HYMallSectionView

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
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 0.5*0.5);
    UIColor *color = [UIColor colorWithHexColor:@"646465" alpha:1.0];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGSize size = [self.title sizeWithFont:[UIFont systemFontOfSize:14]];
    
    CGContextMoveToPoint(context, 30, rect.size.height/2);
    CGContextAddLineToPoint(context, (rect.size.width-size.width)/2-6, rect.size.height/2);
    
    CGContextMoveToPoint(context, (rect.size.width+size.width)/2+6, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width -30, rect.size.height/2);
    
    [color set];
    [self.title drawInRect:CGRectMake((rect.size.width-size.width)/2,
                                      (rect.size.height-size.height)/2,
                                      size.width,
                                      size.height)
                  withFont:[UIFont systemFontOfSize:13]];
    
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

#pragma mark setter/getter
- (void)setTitle:(NSString *)title
{
    if (title != _title)
    {
        _title = title;
        [self setNeedsDisplay];
    }
}

@end
