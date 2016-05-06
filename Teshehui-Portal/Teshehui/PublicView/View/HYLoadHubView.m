//
//  HYLoadHubView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYLoadHubView.h"
#import <QuartzCore/QuartzCore.h>

@interface HYLoadHubView ()
{
    NSTimer *_timer;
}
@property (nonatomic, strong) UIImageView *loadView;

@property (nonatomic, strong) UIImageView *logoFull;
@property (nonatomic, strong) UIImageView *logoDisable;

@property (nonatomic, assign) NSInteger showCount;
@property (nonatomic, assign) NSInteger dismissCount;
@property (nonatomic, assign) BOOL isShow;

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
        _showCount = 0;
        _dismissCount = 0;
        _isShow = NO;
        
        self.userInteractionEnabled = NO;
        
//        UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
//        hudView.layer.cornerRadius = 8;
//		hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//        hudView.center = self.center;
//        [self addSubview:hudView];
        
        CGRect rect = CGRectMake(0, 0, 40, 40);
        
        _logoDisable = [[UIImageView alloc] initWithFrame:rect];
        _logoDisable.image = [UIImage imageNamed:@"load_hub_disable"];
        _logoDisable.contentMode = UIViewContentModeScaleAspectFit;
        _logoDisable.center = self.center;
        [self addSubview:_logoDisable];
        
        rect.origin.x = _logoDisable.frame.origin.x;
        rect.origin.y = _logoDisable.frame.origin.y+30;
        rect.size.height = 10;
        _logoFull = [[UIImageView alloc] initWithFrame:rect];
        _logoFull.image = [UIImage imageNamed:@"load_hub_light"];
        _logoFull.contentMode = UIViewContentModeBottomLeft;
        _logoFull.clipsToBounds = YES;
//        _logoFull.center = self.center;
        [self addSubview:_logoFull];
        
        _loadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_hub_around"]];
        _loadView.contentMode = UIViewContentModeScaleAspectFit;
        _loadView.center = self.center;
        [self addSubview:_loadView];
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

- (void)start
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer =  [NSTimer scheduledTimerWithTimeInterval:0.2
                                               target:self
                                             selector:@selector(updateLoadAnimation:)
                                             userInfo:nil
                                              repeats:YES];
}

- (void)updateLoadAnimation:(NSTimer *)timer
{
    CGRect rect = self.logoFull.frame;
    if (rect.size.height < self.logoDisable.frame.size.height)
    {
        rect.origin.y -= 4;
        rect.size.height += 4;
        if (rect.size.height > self.logoDisable.frame.size.height)
        {
            rect.size.height = self.logoDisable.frame.size.height;
            rect.origin.y = self.logoDisable.frame.origin.y;
        }
    }
    else
    {
        rect.origin.y = self.logoDisable.frame.origin.y+30;
        rect.size.height = 10;
    }
    
    self.logoFull.frame = rect;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

+ (void)show
{
    [[HYLoadHubView sharedView] showWithAnimation];
}

+ (void)dismiss {
    [[HYLoadHubView sharedView] dismissWithAnimation];
}

#pragma mark private methods
- (void)doShowAndDismiss
{
    if (self.showCount >0)
    {
        if (self.isShow)
        {
            self.showCount--;
            [self doShowAndDismiss];
        }
        else
        {
            self.isShow = YES;
            
            if (![self superview])
            {
                UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                [window addSubview:self];
            }
            
            CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            fullRotation.fromValue = [NSNumber numberWithFloat:0];
            fullRotation.toValue = [NSNumber numberWithFloat:MAXFLOAT];
            fullRotation.duration = MAXFLOAT * 0.2;
            fullRotation.removedOnCompletion = YES;
            [_loadView.layer addAnimation:fullRotation forKey:nil];
            
            __weak typeof(self) bself = self;
            
            [UIView animateWithDuration:0.4 animations:^{
                bself.alpha = 1.0;
            } completion:^(BOOL finished) {
                if (finished)
                {
                    bself.showCount--;
                    [bself doShowAndDismiss];
                    [bself start];
                }
            }];
        }
    }
    else if(self.dismissCount)
    {
        __weak typeof(self) bself = self;
        
        [UIView animateWithDuration:0.4
                         animations:^{
                             bself.alpha = 0;
                         } completion:^(BOOL finished) {
                             if (finished)
                             {
                                 [bself.loadView.layer removeAllAnimations];
                                 [bself removeFromSuperview];
                                 bself.dismissCount = 0;
                                 bself.isShow = NO;
                             }
                         }];
    }
}

#pragma mark pulice methods
- (void)showWithAnimation
{
    self.showCount++;
    
    [self doShowAndDismiss];
}

- (void)dismissWithAnimation
{
    self.dismissCount++;
    
    [self doShowAndDismiss];
}
@end
