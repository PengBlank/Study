//
//  HYXibView.m
//  Teshehui
//
//  Created by Kris on 16/2/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYXibView.h"

@interface HYXibView ()

@end

@implementation HYXibView

- (void)dealloc
{
    [[UIApplication sharedApplication] keyWindow].gestureRecognizers = nil;
}

+ (instancetype)instanceView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self)
                                         owner:nil
                                       options:nil]lastObject];
}

#pragma mark HYXibAction protocol
//the class has these methods,but doesnt own
//- (void)performShow
//{
//    /*
//    if ([self.actionDelegate respondsToSelector:@selector(showOfView:)])
//    {
//        [self.actionDelegate showOfView:self];
//    }
//     */
//}
//
//-(void)performTapAction
//{
//    /*
//    if ([self.actionDelegate respondsToSelector:@selector(tapAction:ofView:)])
//    {
//        [self.actionDelegate tapAction:_tap ofView:self];
//    }
//     */
//}

- (void)showOfView:(HYXibView *)view
{
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = [UIScreen mainScreen].bounds;
        [window addSubview:self];
    }
    
    __weak typeof(self) b_self = self;
    b_self.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        b_self.alpha = 1;
    }];
}

- (void)dismiss
{
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
     {
         b_self.alpha = 0;
     } completion:^(BOOL finished)
     {
         [b_self removeFromSuperview];
     }];
}

- (void)tapAction
{
    if ([self respondsToSelector:@selector(performTapAction)])
    {
        [self performTapAction];
    }
}

- (void)awakeFromNib
{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(tapAction)];
//    tap.delegate = self;
//    [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:tap];
}

@end
