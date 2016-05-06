//
//  HYLoadHubView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYLoadHubView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface HYLoadHubView ()
{
    UIImageView *_logoView;
    UIImageView *_loadView;
    BOOL _hidden;
}

@property (nonatomic, strong) UIWindow *overlayWindow;

@end

@implementation HYLoadHubView


+ (HYLoadHubView*)sharedView
{
    static dispatch_once_t once;
    static HYLoadHubView *sharedView;
    dispatch_once(&once, ^ { sharedView = [[HYLoadHubView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code6
        _hidden = YES;
        
        self.userInteractionEnabled = NO;
        //self.backgroundColor = [UIColor greenColor];
        
        CGRect rect = CGRectMake(0, 0, 40, 40);
        UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        hudView.layer.cornerRadius = 8;
		hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        hudView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        hudView.tag = 101;
        hudView.autoresizingMask = UIViewAutoresizingFlexibleAllMargin;
        [self addSubview:hudView];
        
        _logoView = [[UIImageView alloc] initWithFrame:rect];
        _logoView.image = [UIImage imageNamed:@"load_logo"];
        _logoView.contentMode = UIViewContentModeScaleAspectFit;
        _logoView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        _logoView.autoresizingMask = UIViewAutoresizingFlexibleAllMargin;
        [self addSubview:_logoView];
        
        _loadView = [[UIImageView alloc] initWithFrame:rect];
        _loadView.image = [UIImage imageNamed:@"load_around"];
        _loadView.contentMode = UIViewContentModeScaleAspectFit;
        _loadView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        _loadView.autoresizingMask = UIViewAutoresizingFlexibleAllMargin;
        [self addSubview:_loadView];
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view
{
    self = [self initWithFrame:view.bounds];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.userInteractionEnabled = YES;
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //[self orientationChanged:nil];
}

- (void)orientationChanged:(NSNotification *)n
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.bounds = self.superview.bounds;
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            self.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.transform = CGAffineTransformIdentity;
        }
    } else {
        self.bounds = CGRectMake(0, 0, self.superview.bounds.size.height, self.superview.bounds.size.width);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            self.transform = CGAffineTransformMakeRotation(M_PI_2+M_PI);
        } else {
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }
    _logoView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _loadView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIView *hudview = [self viewWithTag:101];
    hudview.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

+ (void)show
{
    [[HYLoadHubView sharedView] showWithAnimation];
}

+ (void)dismiss {
    [[HYLoadHubView sharedView] dismissWithAnimation];
}

+ (void)showWithUserInteractionPrevent:(BOOL)aBool
{
    [[HYLoadHubView sharedView] setUserInteractionEnabled:aBool];
    [self show];
}

#pragma mark setter/getter
- (UIWindow *)overlayWindow {
    if(!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = NO;
    }
    return _overlayWindow;
}

#pragma mark private methods
- (void)showWithAnimation
{
    @synchronized(self) {
        if (!_hidden) {
            return;
        }
    }
    _hidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![self superview])
        {
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window addSubview:self];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
            [self orientationChanged:nil];
        }
        
        CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:MAXFLOAT];
        fullRotation.duration = MAXFLOAT * 0.2;
        fullRotation.removedOnCompletion = YES;
        [_loadView.layer addAnimation:fullRotation forKey:nil];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 1.0;
        }];
        
    });
}

- (void)showWithAnimation:(BOOL)animate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:MAXFLOAT];
        fullRotation.duration = MAXFLOAT * 0.2;
        fullRotation.removedOnCompletion = YES;
        fullRotation.repeatCount = MAXFLOAT;
        [_loadView.layer addAnimation:fullRotation forKey:@"loading"];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 1.0;
        }];
        
    });
}

- (void)hide:(BOOL)animate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        //[UIView animateWithDuration:0.4
        //animations:^{
        self.alpha = 0;
        //} completion:^(BOOL finished) {
        
        //}];
        
    });
}

- (void)dismissWithAnimation
{
    @synchronized(self) {
        if (_hidden)
            return;
    }
    _hidden = YES;
    self.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //[UIView animateWithDuration:0.4
                         //animations:^{
                             self.alpha = 0;
                         //} completion:^(BOOL finished) {
                             [_loadView.layer removeAllAnimations];
                             
                             [self removeFromSuperview];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        
                         //}];
        
    });
}
@end

static char loadingViewKey;

@implementation UIViewController (Loading)

- (void)showLoadingView
{
    [self.loadingView showWithAnimation:YES];
}

- (void)hideLoadingView
{
    [self.loadingView hide:YES];
    [self.loadingView removeFromSuperview];
    objc_setAssociatedObject(self, &loadingViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HYLoadHubView *)loadingView
{
    HYLoadHubView *_loading = objc_getAssociatedObject(self, &loadingViewKey);
    if (!_loading) {
        _loading = [[HYLoadHubView alloc] initWithView:self.view];
        [self.view addSubview:_loading];
        objc_setAssociatedObject(self, &loadingViewKey, _loading, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _loading;
}

- (void)setLoadingView:(HYLoadHubView *)loadingView
{
    //Empty
}

@end
