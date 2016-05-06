//
//  HYProductWebView.m
//  Teshehui
//
//  Created by HYZB on 15/9/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductWebView.h"

@interface HYProductWebView ()<UIGestureRecognizerDelegate>
{
    UIWebView *_webView;
}
@end

@implementation HYProductWebView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _webView = [[UIWebView alloc] initWithFrame:ScreenRect];
        _webView.scalesPageToFit = YES;
        [self addSubview:_webView];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        [_webView addGestureRecognizer:singleTap];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)showWithAnimation:(BOOL)animation
{
    if (![self superview])
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGPoint point = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    if (animation)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 1.0;
                             self.frame = frame;
                         }];
    }
    else
    {
        self.center = point;
    }
}

- (void)dismiss
{
    if ([self superview])
    {
        CGRect frame = TFRectMake(0, 0, 320, 300);
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 0.0;
                             self.frame = frame;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}

#pragma mark private methods
- (void)handleSingleTap:(id)sender
{
    [self dismiss];
}

#pragma mark setter/getter
- (void)setHtmlStr:(NSString *)htmlStr
{
    if (htmlStr != _htmlStr)
    {
        _htmlStr = htmlStr;
        
        [_webView loadHTMLString:htmlStr
                         baseURL:nil];
    }
}

@end
