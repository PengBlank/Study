//
//  HYPopUpView.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYPopUpView.h"

@implementation HYPopUpView

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)])
    {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor whiteColor];
        _dimView = [[UIView alloc] initWithFrame:bounds];
        _dimView.backgroundColor = [UIColor clearColor];
        _dimView.alpha = .7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
        [_dimView addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, bounds.size.height, CGRectGetWidth(bounds), frame.size.height);
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        _dimView = [[UIView alloc] initWithFrame:bounds];
        _dimView.backgroundColor = [UIColor clearColor];
        _dimView.alpha = .5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
        [_dimView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)setDimAlpha:(CGFloat)dimAlpha
{
    _dimView.alpha = dimAlpha;
}

/**
 *  @brief  点按周围取消
 *
 *  @param tap
 */
- (void)bgTap:(UITapGestureRecognizer *)tap
{
    [self dismissWithAnimation:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showWithAnimation:(BOOL)animation
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:_dimView];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    //prepare
    if (_popDirection == HYPopUpFromBottom)
    {
        self.frame = CGRectMake(0, CGRectGetMaxY(frame), self.frame.size.width, self.frame.size.height);
    }
    [window addSubview:self];
    
    
    if (animation)
    {
        [UIView beginAnimations:@"bg" context:nil];
    }
    
    _dimView.backgroundColor = [UIColor blackColor];
    
    if (animation)
    {
        [UIView commitAnimations];
    }
    
    //target!
    CGRect targetFrame = self.frame;
    if (_popDirection == HYPopUpFromBottom)
    {
        targetFrame.origin.y = CGRectGetHeight(frame) - CGRectGetHeight(self.frame);
    }
    if (animation)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = targetFrame;
                         }];
    }
    else
    {
        self.frame = targetFrame;
    }
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if ([self superview])
    {
        if (animation)
        {
            [UIView animateWithDuration:.3 animations:^
             {
                 _dimView.backgroundColor = [UIColor clearColor];
             } completion:^(BOOL finished) {
                 [_dimView removeFromSuperview];
             }];
        }
        else
        {
            [_dimView removeFromSuperview];
        }
        
        CGRect windowFrame = [[UIScreen mainScreen] bounds];
        CGRect targetFrame = self.frame;
        
        if (_popDirection == HYPopUpFromBottom)
        {
            targetFrame.origin.y = CGRectGetHeight(windowFrame);
        }
        
        if (animation)
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.frame = targetFrame;
                             } completion:^(BOOL finished) {
                                 [self removeFromSuperview];
                             }];
        }
        else
        {
            [self removeFromSuperview];
        }
    }
    
}
@end
