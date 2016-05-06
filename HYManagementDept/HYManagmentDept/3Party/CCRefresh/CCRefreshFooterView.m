//
//  CCRefreshFooterView.m
//  CCRefreshView
//
//  Created by Ray on 14-5-25.
//  Copyright (c) 2014年 souvi. All rights reserved.
//

#import "CCRefreshFooterView.h"

extern NSString *const CCRefreshContentOffset;
extern NSString *const CCRefreshContentSize;

@implementation CCRefreshFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView) {
        if (_scrollView) {
            // 1.移除以前的监听器
            [_scrollView removeObserver:self forKeyPath:CCRefreshContentSize context:nil];
        }
        // 2.监听contentSize
        [scrollView addObserver:self forKeyPath:CCRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        [super setScrollView:scrollView];
        
        [self adjustFrame];
    }
}

#pragma mark 监听UIScrollView的属性
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
            
            if (offset <= 0) {
                return;
            }
        }
        
        //NSLog(@"the offset is : %f", offset);
        
        [self moveOffset:offset];
    }
}

#pragma mark 重写调整frame
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

#pragma mark - 状态相关
#pragma mark 设置状态
- (void)setState:(CCRefreshState)state
{
    if (_state == state) return;
    [super setState:state];
    
	switch (state)
    {
		case CCRefreshStateWillRefreshing:
        case CCRefreshStateNormal:
        {
            if (_scrollView.contentInset.bottom != _scrollViewInitInset.bottom) {
                [UIView animateWithDuration:.25 animations:^{
                    UIEdgeInsets inset = _scrollView.contentInset;
                    inset.bottom = _scrollViewInitInset.bottom;
                    _scrollView.contentInset = inset;
                }];
            }
			break;
        }
            
        case CCRefreshStateRefreshing:
        {
            [UIView animateWithDuration:.25 animations:^{
                UIEdgeInsets inset = _scrollView.contentInset;
                CGFloat bottom = self.refreshHeight + _scrollViewInitInset.bottom;
                // 内容的高度
                CGFloat contentHeight = _scrollView.contentSize.height + _scrollViewInitInset.top + _scrollViewInitInset.bottom;
                // 表格的高度
                CGFloat scrollHeight = _scrollView.frame.size.height;
                if (scrollHeight > contentHeight) {
                    bottom += scrollHeight - contentHeight;
                }
                inset.bottom = bottom;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
        default:
            break;
	}
}

- (void)free
{
    [super free];
    [_scrollView removeObserver:self forKeyPath:CCRefreshContentSize];
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
