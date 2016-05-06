//
//  HYO2OFilterView.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYO2OFilterView.h"

@implementation HYO2OFilterView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor whiteColor];
        _clickSelected = NO;
        [self addSubview:_lineView];
        
        UIImageView *triangleLeft = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aroundMall_input"]];
        triangleLeft.frame = CGRectMake(self.frame.size.width/2 - 15, self.frame.size.height - 15, 10, 10);
        [self addSubview:triangleLeft];
        
        UIImageView *triangleRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aroundMall_input"]];
        triangleRight.frame = CGRectMake(self.frame.size.width - 15, self.frame.size.height - 15, 10, 10);
        [self addSubview:triangleRight];
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
    
    //bottom line
    CGContextMoveToPoint(context, 0, rect.size.height-0.5*0.5);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5*0.5);
    
    CGFloat step = rect.size.width/[self.conditions count];
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.6 alpha:1.0].CGColor);
    
    for (int i=1; i<[self.conditions count]; i++)
    {
        CGContextMoveToPoint(context, step*i, 3);
        CGContextAddLineToPoint(context, step*i, rect.size.height-6);
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    if (!_clickSelected)
    {
        [[UIColor colorWithWhite:0.2 alpha:1.0] set];
        for (int i=0; i<[self.conditions count]; i++)
        {
            NSString *str = [self.conditions objectAtIndex:i];
            
            [str drawInRect:CGRectMake(step*i, (rect.size.height-14)/2-2, step, 28)
                   withFont:[UIFont systemFontOfSize:14]
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentCenter];
        }
        
    }else
    {
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
                   withFont:[UIFont systemFontOfSize:14]
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentCenter];
        }
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
    
    //点击序号与已有序号不同则开始更新绘图
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
//                _lineView.frame = CGRectMake(widthPerItem*itemIndex+(widthPerItem-38)/2, frame.size.height-3, 38, 2);
            }];
            _clickSelected = YES;
            if (_clickSelected)
            {
                _lineView.backgroundColor = [UIColor colorWithRed:161.0/255.0
                                                            green:0
                                                             blue:0
                                                            alpha:1.0];
            }
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }else {
        //再次点同一个时取消选中状态
        if (!_clickSelected)
        {
            _lineView.backgroundColor = [UIColor colorWithRed:161.0/255.0
                                                        green:0
                                                         blue:0
                                                        alpha:1.0];
            _clickSelected = YES;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            [self setNeedsDisplay];
        }else
        {
            _clickSelected = NO;
            _lineView.backgroundColor = [UIColor whiteColor];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            [self setNeedsDisplay];
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
        
//        CGFloat width = self.frame.size.width/[self.conditions count];
//        [_lineView setFrame:CGRectMake((width-38)/2, self.frame.size.height-3, 38, 2)];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
