//
//  HYPageViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-31.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYPageViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInViewController;
- (UIViewController *)viewForPageAtIndex:(NSInteger)index;

@end

@protocol HYPageViewDelegate <NSObject>

@optional
- (void)didScrollPageIndex:(NSInteger)index;

@end

@interface HYPageViewControl : UIView

@property (nonatomic, weak) id<HYPageViewDataSource> dataSource;
@property (nonatomic, weak) id<HYPageViewDelegate> delegate;

@end
