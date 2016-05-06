//
//  HYShareGetPointView.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYShareGetPointView.h"
#import "UIImage+Addition.h"

@implementation HYShareGetPointView

+ (HYShareGetPointView *)sharedView
{
    static dispatch_once_t once;
    static HYShareGetPointView *sharedView;
    dispatch_once(&once, ^ { sharedView = [[HYShareGetPointView alloc] initWithDefualt]; });
    return sharedView;
}

- (id)initWithDefualt
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat size = 100;
    self = [super initWithFrame:CGRectMake(frame.size.width - size, 220, size, size)];
    if (self)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        UIImage *image = [UIImage imageNamed:@"icon_sharegetpoint"];
        image = [image imageWithScaleSize:CGSizeMake(size, size)];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(checkBuyCarEvent:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
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
#pragma mark private methods
- (void)checkBuyCarEvent:(id)sender
{
    if (_isHalfHidden)
    {
        [self showInView:self.superview];
    }
    else
    {
        if (self.didCheck)
        {
            self.didCheck();
        }
    }
}


#pragma mark public methods
- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [self showInView:window];
}

- (void)showInView:(UIView *)view
{
    if (view != self.superview) {
        [self dismiss];
    }
    
    _isHalfHidden = NO;
    
    self.transform = CGAffineTransformIdentity;
    [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:self];
    
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(windowFrame.size.width - self.frame.size.width - 5,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isHalfHidden = YES;
        [self setAnchorPoint:CGPointMake(1, 0) forView:self];
        [UIView animateWithDuration:.3 animations:^{
            //            self.frame = CGRectMake(windowFrame.size.width-self.frame.size.width/2,
            //                                    self.frame.origin.y,
            //                                    self.frame.size.width,
            //                                    self.frame.size.height);
            self.transform = CGAffineTransformMakeRotation(-M_PI / 3);
        }];
    });
    
    if (!self.superview && view != self.superview)
    {
        [view addSubview:self];
    }
    
    [view bringSubviewToFront:self];
}

- (void)dismiss
{
    self.didCheck = nil;
    
    if (self.superview)
    {
        [self removeFromSuperview];
    }
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
