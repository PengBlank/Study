//
//  HYFlightWarningView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightWarningView.h"

@interface HYFlightWarningView ()
{
    UILabel *_label;
}

@end

@implementation HYFlightWarningView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 40)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _label.backgroundColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.center = self.center;
        [self addSubview:_label];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismiss];
}

#pragma mark setter/getter
- (void)setMsg:(NSString *)msg
{
    if (msg != _msg)
    {
        _msg = msg;
        _label.text = msg;
    }
}

- (void)show
{
    if (!self.superview)
    {
        self.alpha = 0.0;
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 1.0;
                         }];
    }
}

- (void)dismiss
{
    if (self.superview)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}

@end
