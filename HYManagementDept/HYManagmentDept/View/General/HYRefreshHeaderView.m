//
//  HYRefreshHeaderView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-26.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYRefreshHeaderView.h"
#include "HYStyleConst.h"

#define FLIP_ANIMATION_DURATION 0.18f

@implementation HYRefreshHeaderView

//0 - 100
- (void)setRadis:(NSInteger)ra
{
    if (ra == 0)
    {
        self.activityView.layer.mask = nil;
    }
    else
    {
        CGFloat x = ra / 100.0;
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.frame = self.activityView.bounds;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, CGRectGetMidX(_activityView.bounds), CGRectGetMidY(_activityView.bounds));
        CGPathAddArc(path, NULL, CGRectGetMidX(_activityView.bounds), CGRectGetMidY(_activityView.bounds), CGRectGetMidX(_activityView.bounds), -M_PI/2, x * M_PI * 2 - M_PI_2, false);
        shape.fillColor = [UIColor redColor].CGColor;
        shape.path = path;
        //[self.active.layer addSublayer:shape];
        self.activityView.layer.mask = shape;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat fontSize;
        CGFloat refreshHeight;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            fontSize = 15.0;
            refreshHeight = 65;
        }
        else
        {
            fontSize = 12.0;
            refreshHeight = 40;
        }
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		label.font = [UIFont boldSystemFontOfSize:fontSize];
        label.textColor = kTableSubcontentColor;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        view.hidesWhenStopped = NO;
        view.color = kTableSubcontentColor;
		[self addSubview:view];
		_activityView = view;
        
        self.refreshHeight = refreshHeight;
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super initWithScrollView:scrollView]) {
        self.frame = CGRectMake(0, -CGRectGetHeight(scrollView.frame), CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame));
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _statusLabel.frame = CGRectMake(0.0f, CGRectGetHeight(self.frame) - self.refreshHeight/2 - 10, CGRectGetWidth(self.frame), 20.0f);
    _activityView.frame = CGRectMake(CGRectGetMidX(self.bounds)-120, CGRectGetHeight(self.frame) - self.refreshHeight/2-10, 20.0f, 20.0f);
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    self.frame = CGRectMake(0, 0, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame));
    [super setScrollView:scrollView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![CCRefreshContentOffset isEqualToString:keyPath]) return;
    
    CGFloat offset = -_scrollView.contentOffset.y;
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
        || _state == CCRefreshStateRefreshing) return;
    
    
    //NSLog(@"the offset is %f", offset);
    
    CGFloat reheight = self.refreshHeight;
    if (offset < reheight && !self.activityView.isAnimating && offset > -1) {
        [self setRadis:(offset / reheight * 100)];
    } else if (offset >= reheight)
    {
        [self setRadis:0];
        [self.activityView startAnimating];
    }
    else
    {
        
    }
    
    if (offset <= 0) {
        return;
    }
    
    [self moveOffset:offset];
}

- (void)setState:(CCRefreshState)state
{
    switch (state) {
        case CCRefreshStateWillRefreshing:
            self.statusLabel.text = @"释放开始刷新...";
            break;
        case CCRefreshStateNormal:
            if (_state == CCRefreshStateWillRefreshing) {
                [self setRadis:0];
			}
            self.statusLabel.text = @"继续下拉可以刷新...";
            [_activityView stopAnimating];
            break;
        case CCRefreshStateRefreshing:
            self.statusLabel.text = @"刷新中...";
            [_activityView startAnimating];
            break;
        default:
            break;
    }
    [super setState:state];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
