//
//  HYTableViewFooterView.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-14.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 列表底部加载更多界面
 */

#import <UIKit/UIKit.h>

@interface HYTableViewFooterView : UIView

@property (nonatomic, readonly,assign) BOOL loadFinish;

//@property (nonatomic, assign) BOOL needShowLine; //

@property (nonatomic, readonly, retain) UIActivityIndicatorView *loadView;
@property (nonatomic, readonly, retain) UILabel *loadText;

- (void)startLoadMore;
- (void)stopLoadMore;

@end
