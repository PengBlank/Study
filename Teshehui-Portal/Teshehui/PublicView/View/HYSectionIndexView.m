//
//  HYSectionIndexView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYSectionIndexView.h"

@interface HYSectionIndexView ()
{
    NSTimer *_timer;
    NSString *_preText;
}
@end

@implementation HYSectionIndexView

- (void)dealloc
{
    if (_timer && [_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (id)initWithDefault
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake((bounds.size.width-80)/2, (bounds.size.height-60)/2, 80, 60);
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:40];
        self.textColor = [UIColor colorWithRed:60.0f/255.0f
                                         green:175.0f/255.0f
                                          blue:220.0f/255.0f
                                         alpha:1.0f];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

#pragma mark setter/getter
- (void)setText:(NSString *)text
{
    [super setText:text];
    _preText = [text copy];
}

#pragma mark private methods
- (void)updateStatus:(NSTimer *)timer
{
    if ([_preText isEqualToString:self.text])
    {
        [self dismiss];
    }
}

- (void)show
{
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 1.0;
                         }];
        
        if (!_timer)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                      target:self
                                                    selector:@selector(updateStatus:)
                                                    userInfo:nil
                                                     repeats:YES];
        }
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
                             if (_timer && [_timer isValid])
                             {
                                 [_timer invalidate];
                                 _timer = nil;
                             }
                             
                             [self removeFromSuperview];
                         }];
    }
}
@end
