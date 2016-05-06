//
//  PageBaseLoading.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PageBaseLoading.h"
#import "DefineConfig.h"
#import "UIView+Frame.h"
static UIView *loadingView = nil;
static NSInteger loadingViewCount = 0;


@interface PageBaseLoading ()
{
    NSTimer         *_timer;
    BOOL            _isShow;
}
@end


@implementation PageBaseLoading

+ (PageBaseLoading *)sharedView
{
    static dispatch_once_t once;
    static PageBaseLoading *sharedView;
    dispatch_once(&once, ^ { sharedView = [[PageBaseLoading alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self setup];
    }
    return self;
}

- (UIView *)animtionView{
    if (!_animtionView) {
        _animtionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _animtionView.backgroundColor = [UIColor clearColor];
//        _animtionView.userInteractionEnabled = YES;
        
    }
    return _animtionView;
}

- (UIImageView *)circleImageView{
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_hub_around"]];
        [_circleImageView setCenter:self.animtionView.center];
    }
    
    return _circleImageView;
}

- (UIImageView *)normalImageView{
    if (!_normalImageView) {
        _normalImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_hub_light"]];
        [_normalImageView setFrame:CGRectMake(self.translucentImageView.frame.origin.x, self.translucentImageView.frame.origin.y + 30, 40, 10)];
        //        [_normalImageView setCenter:self.animtionView.center];
        _normalImageView.contentMode = UIViewContentModeBottomLeft;
        _normalImageView.clipsToBounds = YES;
    }
    
    return _normalImageView;
}

- (UIImageView *)translucentImageView{
    
    if (!_translucentImageView) {
        _translucentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_hub_disable"]];
        [_translucentImageView setFrame:CGRectMake(0, 0, 40, 40)];
        _translucentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_translucentImageView setCenter:self.center];
    }
    
    return _translucentImageView;
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    _animtionView.center = newSuperview.center;
}

- (void)setup{
    
    
    [self addSubview:self.animtionView];
    [self addSubview:self.circleImageView];
    [self addSubview:self.translucentImageView];
    [self addSubview:self.normalImageView];
}

+ (void)showLoading
{
    [[PageBaseLoading sharedView] performSelectorOnMainThread:@selector(showStartAnimation) withObject:nil waitUntilDone:NO];
}

- (void)showStartAnimation{
    
   
    
    if (![self superview])
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    loadingViewCount++;
//    if (!_isShow) {
//        return;
//    }

    CABasicAnimation *animtaion = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animtaion.duration = 1.3;//动画周期
    animtaion.removedOnCompletion = YES;
    animtaion.repeatCount = INT64_MAX;
    animtaion.fromValue = @0.f;
    animtaion.toValue = @(360*M_PI/180.0f);
    animtaion.delegate = self;
    

    
    [self.circleImageView.layer addAnimation:animtaion forKey:@"zhuanquan"];
    [self start];

    
     DebugNSLog(@"showCount  === %@",@(loadingViewCount));
}

//- (void)animationDidStart:(CAAnimation *)anim{
//     DebugNSLog(@"animation Start  === %@",@(loadingViewCount));
//    _isShow = YES;
//}
//
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//     DebugNSLog(@"animation finished  === %@",@(loadingViewCount));
//    _isShow = NO;
//}


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
    CGRect rect = self.normalImageView.frame;
    if (rect.size.height < self.translucentImageView.frame.size.height)
    {
        rect.origin.y -= 4;
        rect.size.height += 4;
        if (rect.size.height > self.translucentImageView.frame.size.height)
        {
            rect.size.height = self.translucentImageView.frame.size.height;
            rect.origin.y = self.translucentImageView.frame.origin.y;
        }
    }
    else
    {
        rect.origin.y = self.translucentImageView.frame.origin.y+30;
        rect.size.height = 10;
    }
    
    self.normalImageView.frame = rect;
}


+ (void)hide_Load
{
    [[PageBaseLoading sharedView] performSelectorOnMainThread:@selector(hiddeLoad_anywayInner) withObject:nil waitUntilDone:NO];
}

- (void)hiddeLoad_anywayInner
{
    // 减去计数
    loadingViewCount--;
    if (loadingViewCount <= 0)
    {
        [self.circleImageView.layer removeAllAnimations];
        [self removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
        loadingViewCount = 0;
    }
    
      DebugNSLog(@"dismissCount  === %@",@(loadingViewCount));
}


+ (void)hiddeLoad_anyway
{
    loadingViewCount = 0;
    [[PageBaseLoading sharedView] forceHideLoad];
}

- (void)forceHideLoad{
    [self.circleImageView.layer removeAllAnimations];
    [self removeFromSuperview];
    [_timer invalidate];
    _timer = nil;
}






@end
