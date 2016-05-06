//
//  HYHYMallOrderListFilterView.m
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHYMallOrderListFilterView.h"

@implementation HYHYMallOrderListFilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                               green:246.0/255.0
                                                blue:246.0/255.0
                                               alpha:1.0f];
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithRed:161.0/255.0
                                                    green:0
                                                     blue:0
                                                    alpha:1.0];
        [self addSubview:_lineView];
        
        _showSpecLine = YES;
        self.titleFont = [UIFont systemFontOfSize:14];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 0.5*0.5);
    
    CGFloat step = rect.size.width/[self.conditions count];
    
    if (self.showSpecLine)
    {
        //bottom line
        CGContextMoveToPoint(context, 0, rect.size.height-0.5*0.5);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5*0.5);
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.6 alpha:1.0].CGColor);
        
        for (int i=1; i<[self.conditions count]; i++)
        {
            CGContextMoveToPoint(context, step*i, 6);
            CGContextAddLineToPoint(context, step*i, rect.size.height-12);
        }
    }
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    for (int i=0; i<[self.conditions count]; i++)
    {
        NSString *str = [self.conditions objectAtIndex:i];
        
        if (i != _currentIndex)
        {
            [[UIColor colorWithWhite:0.2 alpha:1.0] set];
        }
        else
        {
            [[UIColor colorWithRed:161.0/255.0
                             green:0
                              blue:0
                             alpha:1.0] set];
        }
        
        [str drawInRect:CGRectMake(step*i, (rect.size.height-14)/2-2, step, 28)
               withFont:self.titleFont
          lineBreakMode:NSLineBreakByWordWrapping
              alignment:NSTextAlignmentCenter];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    CGPoint location = [touch locationInView:self];
    CGRect frame = [self frame];
    
    //计算触点序号
    CGFloat widthPerItem = frame.size.width / (CGFloat)[self.conditions count];
    _touchBeganIndex = floor(location.x / widthPerItem);
    
    //点击序号与已有序号不同则开始 更新绘图
    _valueChange = (_touchBeganIndex != _currentIndex);
    if (_valueChange)
    {
        _currentIndex = _touchBeganIndex;
    }
    
    return YES;
}

//在这个界面，手指移动时cancelled被调用
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];
    
    _valueChange = NO;
    _currentIndex = -1;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    if (_valueChange)
    {
        CGPoint location = [touch locationInView:self];
        CGRect frame = [self frame];
        CGFloat widthPerItem = frame.size.width / (CGFloat)[self.conditions count];
        NSUInteger itemIndex = floor(location.x / widthPerItem);
        
        if (itemIndex == _touchBeganIndex)
        {
            _currentIndex = _touchBeganIndex;

            [self setNeedsDisplay];
            
            [UIView animateWithDuration:0.33 animations:^{
                _lineView.frame = CGRectMake(widthPerItem*itemIndex+(widthPerItem-38)/2, frame.size.height-3, 38, 2);
            }];
            
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

#pragma mark setter/getter
- (void)setConditions:(NSArray *)conditions
{
    if (_conditions != conditions)
    {
        _conditions = conditions;
        
        [self setNeedsDisplay];
        
        CGFloat width = self.frame.size.width/(CGFloat)[self.conditions count];
        [_lineView setFrame:CGRectMake((width-38)/2, self.frame.size.height-3, 38, 2)];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex != _currentIndex)
    {
        _currentIndex = currentIndex;

        [self setNeedsDisplay];
        
        CGFloat widthPerItem = self.frame.size.width / (CGFloat)[self.conditions count];
        
        [UIView animateWithDuration:0.33 animations:^{
            _lineView.frame = CGRectMake(widthPerItem*currentIndex+(widthPerItem-38)/2, self.frame.size.height-3, 38, 2);
        }];
    }
}
@end
