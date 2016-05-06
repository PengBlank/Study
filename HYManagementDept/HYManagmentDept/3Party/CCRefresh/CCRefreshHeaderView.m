//
//  CCRefreshHeaderView.m
//  CCRefreshView
//
//  Created by Ray on 14-5-25.
//  Copyright (c) 2014年 souvi. All rights reserved.
//

#import "CCRefreshHeaderView.h"

@implementation CCRefreshHeaderView

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
    [super setScrollView:scrollView];
    
    CGRect frame = self.frame;
    frame = CGRectMake(0, -CGRectGetHeight(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
    self.frame = frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![CCRefreshContentOffset isEqualToString:keyPath]) return;
    
    CGFloat offset = -_scrollView.contentOffset.y;
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
        || _state == CCRefreshStateRefreshing) return;
    
    
    //NSLog(@"the offset is %f", offset);
    if (offset <= 0) {
        return;
    }
    
    [self moveOffset:offset];
}

#pragma mark 设置状态
- (void)setState:(CCRefreshState)state
{
    // 1.一样的就直接返回
    if (_state == state) return;
    
    // 2.保存旧状态
    CCRefreshState oldState = _state;
    
    // 3.调用父类方法
    [super setState:state];
    
    // 4.根据状态执行不同的操作
	switch (state) {
		case CCRefreshStateWillRefreshing: // 松开可立即刷新
        {
            // 执行动画
            [UIView animateWithDuration:.25 animations:^{
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
		case CCRefreshStateNormal: // 下拉可以刷新
        {
            // 执行动画
            [UIView animateWithDuration:.25 animations:^{
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top;
                _scrollView.contentInset = inset;
            }];
            
            // 刷新完毕
            if (CCRefreshStateRefreshing == oldState) {
                // 保存刷新时间
            }
			break;
        }
            
		case CCRefreshStateRefreshing: // 正在刷新中
        {
            [UIView animateWithDuration:.25 animations:^{
                // 1.增加65的滚动区域
                UIEdgeInsets inset = _scrollView.contentInset;
                float height = self.refreshHeight;
                inset.top = _scrollViewInitInset.top + height;
                _scrollView.contentInset = inset;
                // 2.设置滚动位置
                _scrollView.contentOffset = CGPointMake(0, - _scrollViewInitInset.top - height);
            }];
			break;
        }
            
        default:
            break;
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
