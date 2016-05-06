//
//  CCRefreshBaseView.h
//  CCRefreshView
//
//  Created by Ray on 14-5-25.
//  Copyright (c) 2014年 souvi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 枚举
 */
// 控件的刷新状态
typedef enum {
	CCRefreshStateWillRefreshing = 1, // 已拉动到位置，即将进入刷新状态
	CCRefreshStateNormal = 2, // 普通状态
	CCRefreshStateRefreshing = 3, // 正在刷新中的状态
} CCRefreshState;

@class CCRefreshBaseView;

/**
 回调的Block定义
 */
// 开始进入刷新状态就会调用
typedef void (^BeginRefreshingBlock)(CCRefreshBaseView *refreshView);
// 刷新完毕就会调用
typedef void (^EndRefreshingBlock)(CCRefreshBaseView *refreshView);
// 刷新状态变更就会调用
typedef void (^RefreshStateChangeBlock)(CCRefreshBaseView *refreshView, CCRefreshState state);

/**
 代理的协议定义
 */
@protocol CCRefreshBaseViewDelegate <NSObject>
@optional
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(CCRefreshBaseView *)refreshView;
// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(CCRefreshBaseView *)refreshView;
// 刷新状态变更就会调用
- (void)refreshView:(CCRefreshBaseView *)refreshView stateChange:(CCRefreshState)state;
@end

@interface CCRefreshBaseView : UIView
{
    // 父控件一开始的contentInset
    UIEdgeInsets _scrollViewInitInset;
    
    // 父控件
    __weak UIScrollView *_scrollView;
    
    // 状态
    CCRefreshState _state;
    
    __weak id _delegate;
    
    BOOL _hasInitInset;
    
    BeginRefreshingBlock _beginRefreshingBlock;
    RefreshStateChangeBlock _refreshStateChangeBlock;
    EndRefreshingBlock _endStateChangeBlock;
}

// 构造方法
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
// 设置要显示的父控件
@property (nonatomic, weak) UIScrollView *scrollView;

// Block回调
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
@property (nonatomic, copy) RefreshStateChangeBlock refreshStateChangeBlock;
@property (nonatomic, copy) EndRefreshingBlock endStateChangeBlock;
// 代理
@property (nonatomic, weak) id<CCRefreshBaseViewDelegate> delegate;

@property (nonatomic, assign) CGFloat refreshHeight;

// 是否正在刷新
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
// 开始刷新
- (void)beginRefreshing;
// 结束刷新
- (void)endRefreshing;
// 不静止地结束刷新
//- (void)endRefreshingWithoutIdle;
// 结束使用、释放资源
- (void)free;

- (void)setState:(CCRefreshState)state;

/**
 *  scroll view滑动时的处理，根据拉动距离改变状态
 *
 *  @param offset    拉动的距离，对于header,为向下拉动的距离
 */
- (void)moveOffset:(CGFloat)offset;

@end

extern NSString *const CCRefreshContentOffset;
extern NSString *const CCRefreshContentSize;
