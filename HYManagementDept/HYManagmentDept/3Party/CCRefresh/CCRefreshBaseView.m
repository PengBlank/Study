//
//  CCRefreshBaseView.m
//  CCRefreshView
//
//  Created by Ray on 14-5-25.
//  Copyright (c) 2014年 souvi. All rights reserved.
//

#import "CCRefreshBaseView.h"

NSString *const CCRefreshContentOffset = @"contentOffset";
NSString *const CCRefreshContentSize = @"contentSize";

@implementation CCRefreshBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _hasInitInset = NO;
        _state = CCRefreshStateNormal;
        _refreshHeight = 60;
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init]) {
        self.scrollView = scrollView;
        _hasInitInset = NO;
        _state = CCRefreshStateNormal;
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView) {
        if (_scrollView) {
            // 移除之前的监听器
            [_scrollView removeObserver:self forKeyPath:CCRefreshContentOffset context:nil];
        }
        // 监听contentOffset
        [scrollView addObserver:self forKeyPath:CCRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        _scrollView = scrollView;
        _scrollViewInitInset = scrollView.contentInset;
        [_scrollView addSubview:self];
        
        [self setState:CCRefreshStateNormal];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_hasInitInset) {
        _scrollViewInitInset = _scrollView.contentInset;
        
        //[self observeValueForKeyPath:CCRefreshContentSize ofObject:nil change:nil context:nil];
        
        _hasInitInset = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //e
}

- (void)moveOffset:(CGFloat)offset
{
    CGFloat validOffset = self.refreshHeight;
    if (_scrollView.isDragging) {
        //在正在拉动的情况下，如果当前状态是即将刷新，说明之前已拉到位置，但当前offset不够
        //这时转为普通状态
        if (_state == CCRefreshStateWillRefreshing && offset <= validOffset) {
            [self setState:CCRefreshStateNormal];
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:CCRefreshStateNormal];
            }
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, CCRefreshStateNormal);
            }
        }
        //之前的状态是正常，但拉动位置满足
        //这时应该转为即将刷新状态，等待用户释放手指
        else if (_state == CCRefreshStateNormal && offset > validOffset) {
            [self setState:CCRefreshStateWillRefreshing];
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:CCRefreshStateWillRefreshing];
            }
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, CCRefreshStateWillRefreshing);
            }
        }
    } else { // 即将刷新 && 手松开 && 滑动完毕
        if (_state == CCRefreshStateWillRefreshing)
        {
            if (_scrollView.isDecelerating)
            {
                [_scrollView setDecelerationRate:0];
            }
            
            // 开始刷新
            [self setState:CCRefreshStateRefreshing];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:CCRefreshStateRefreshing];
            }
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, CCRefreshStateRefreshing);
            }
        }
    }
}

#pragma mark 设置状态
- (void)setState:(CCRefreshState)state
{
    if (_state != CCRefreshStateRefreshing) {
        // 存储当前的contentInset
        _scrollViewInitInset = _scrollView.contentInset;
    }
    
    // 1.一样的就直接返回
    if (_state == state) return;
    
    // 2.根据状态执行不同的操作
    switch (state) {
		case CCRefreshStateNormal: // 普通状态
            
            // 说明是刚刷新完毕 回到 普通状态的
            if (CCRefreshStateRefreshing == _state) {
                // 通知代理
                if ([_delegate respondsToSelector:@selector(refreshViewEndRefreshing:)]) {
                    [_delegate refreshViewEndRefreshing:self];
                }
                
                // 回调
                if (_endStateChangeBlock) {
                    _endStateChangeBlock(self);
                }
            }
            
			break;
            
        case CCRefreshStateWillRefreshing:
            break;
            
		case CCRefreshStateRefreshing:
            
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshViewBeginRefreshing:)]) {
                [_delegate refreshViewBeginRefreshing:self];
            }
            
            // 回调
            if (_beginRefreshingBlock) {
                _beginRefreshingBlock(self);
            }
			break;
        default:
            break;
	}
    
    // 3.存储状态
    _state = state;
}

- (BOOL)isRefreshing
{
    return CCRefreshStateRefreshing == _state;
}

#pragma mark 开始刷新
- (void)beginRefreshing
{
    //if (self.window) {
        [self setState:CCRefreshStateRefreshing];
    //} else {
        //_state = CCRefreshStateWillRefreshing;
    //}
}

#pragma mark 结束刷新
- (void)endRefreshing
{
    double delayInSeconds =  0.3 ;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setState:CCRefreshStateNormal];
    });
}

- (void)free
{
    [_scrollView removeObserver:self forKeyPath:CCRefreshContentOffset];
}

- (void)removeFromSuperview
{
    [self free];
    _scrollView = nil;
    [super removeFromSuperview];
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
