//
//  HYRefreshFooterView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-26.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYRefreshFooterView.h"
#include "HYStyleConst.h"

#define FLIP_ANIMATION_DURATION 0.18f

@implementation HYRefreshFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        CGFloat fontSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            fontSize = 15.0;
            self.refreshHeight = 65;
        }
        else
        {
            fontSize = 12.0;
            self.refreshHeight = 40;
        }
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0, self.frame.size.width, 20.0f)];
		label.font = [UIFont boldSystemFontOfSize:fontSize];
        label.textColor = kTableBackColor;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(75.0f, 27, 20.0f, 20.0f);
        view.hidesWhenStopped = NO;
		[self addSubview:view];
		_activityView = view;
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super initWithScrollView:scrollView])
    {
        self.frame = CGRectMake(0, CGRectGetHeight(scrollView.frame), CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame));
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _statusLabel.frame = CGRectMake(0.0f, self.refreshHeight/2 - 10, CGRectGetWidth(self.frame), 20.0f);
    _activityView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 120, self.refreshHeight/2 - 10, 20.0f, 20.0f);
}


- (void)setState:(CCRefreshState)state
{
    switch (state) {
        case CCRefreshStateWillRefreshing:
            self.statusLabel.text = @"释放将会加载...";
            break;
        case CCRefreshStateNormal:
            if (_state == CCRefreshStateWillRefreshing) {
        
			}
            
            self.statusLabel.text = @"继续上拉加载...";
            [_activityView stopAnimating];
			
            break;
        case CCRefreshStateRefreshing:
            self.statusLabel.text = @"加载中...";
            [_activityView startAnimating];
            break;
        default:
            break;
    }
    [super setState:state];
}

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

- (void)adjustFrame
{
    // 内容的高度
    CGFloat contentHeight = _scrollView.contentSize.height + _scrollViewInitInset.top + _scrollViewInitInset.bottom;
    // 表格的高度
    CGFloat scrollHeight = _scrollView.frame.size.height;
    CGFloat y = contentHeight > scrollHeight ? contentHeight : scrollHeight;
    // 设置边框
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([CCRefreshContentSize isEqualToString:keyPath]) {
        [self adjustFrame];
    }
    
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
        || _state == CCRefreshStateRefreshing) {
        return;
    }
    
    
    
    if ([CCRefreshContentOffset isEqualToString:keyPath]) {
        CGFloat offset = 0;
        // 内容的高度
        CGFloat contentHeight = _scrollView.contentSize.height + _scrollViewInitInset.top + _scrollViewInitInset.bottom;
        // 表格的高度
        CGFloat scrollHeight = _scrollView.frame.size.height;
        
        if (scrollHeight > contentHeight) {
            offset = _scrollView.contentOffset.y;
        } else {
            //计算offset, offset = 偏移量 + 整页高度
            //这个offset 是scroll view 滑动的结果
            offset = _scrollView.contentOffset.y + _scrollView.frame.size.height;
            
            //计算相对底部偏移量
            //offset = 整体偏移 - content高度 - inset高度
            //初始inset 在加入footer时也会被加放，这时应该也被计算进去
            offset = offset - _scrollView.contentSize.height - _scrollViewInitInset.top - _scrollViewInitInset.bottom;
            
            if (offset < 60 && !self.activityView.isAnimating && offset > -1) {
                [self setRadis:(offset / 60 * 100)];
            } else if (offset >= 60)
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
        }
        
        //NSLog(@"the offset is : %f", offset);
        
        [self moveOffset:offset];
    }
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
