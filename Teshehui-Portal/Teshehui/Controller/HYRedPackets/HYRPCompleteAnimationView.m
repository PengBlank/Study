//
//  HYRPCompleteAnimationView.m
//  Teshehui
//
//  Created by apple on 15/3/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPCompleteAnimationView.h"
#import "UIView+ScreenTransform.h"

@implementation HYRPCompleteAnimationView

+ (instancetype)view
{
    UINib *nib = [UINib nibWithNibName:@"HYRPCompleteAnimationView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    if (views.count > 0) {
        return [views objectAtIndex:0];
    }
    return nil;
}

+ (instancetype)sharedView
{
    static HYRPCompleteAnimationView *__sharedView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedView = [self view];
    });
    return __sharedView;
}

- (void)awakeFromNib
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.frame = window.bounds;
    
//    //一个在右边
//    CGRect frame = _coin.frame;
//    frame = TFREctMakeWithRect(frame);
//    
//    //一个在左边
//    frame = _coin2.frame;
//    frame = TFREctMakeWithRect(frame);
    
    //包包在下边
    CGRect frame = _bag.frame;
    frame = TFREctMakeWithRect(frame);
    frame.origin.y = CGRectGetHeight(self.frame) - frame.size.height;
    _bag.frame = frame;
}

- (void)resetLeftCoin
{
    CGRect frame;
    frame = _coin2.frame;
    frame.origin.y = -frame.size.height;
    frame.origin.x = arc4random_uniform(self.frame.size.width + 1);
    _coin2.frame = frame;
}

- (void)resetRightCoin
{
    CGRect frame = _coin.frame;
    frame.origin.y = -frame.size.height;
    frame.origin.x = arc4random_uniform(self.frame.size.width + 1);
    _coin.frame = frame;
}

+ (void)show
{
    HYRPCompleteAnimationView *view = [self sharedView];
    if (!view.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:view];
    }
    [view startAnimation];
}

+ (void)dismiss
{
    HYRPCompleteAnimationView *view = [self sharedView];
    [view stopAnimation];
    [view removeFromSuperview];
}

- (void)startAnimation
{
    CGPoint target = CGPointMake(self.frame.size.width/2,
                                 CGRectGetMinY(_bag.frame)+TFScalePoint(172));
    
    [self resetLeftCoin];
    [self resetRightCoin];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _coin.center = target;
    } completion:^(BOOL finished)
    {
        if (finished)
        {
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _coin2.center = target;
            } completion:^(BOOL finished)
             {
                 if (finished)
                 {
                     [self startAnimation];
                 }
             }];
        }
    }];
}

- (void)stopAnimation
{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
