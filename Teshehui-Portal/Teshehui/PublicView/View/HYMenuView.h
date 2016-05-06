//
//  HYMenuView.h
//  Teshehui
//
//  Created by 回亿资本 on 14-5-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYMenuViewDelegate <NSObject>

@optional
- (void)didSelectedMenuItem:(id)item;

@end

@interface HYMenuView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<HYMenuViewDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)setMenuViewShow:(BOOL)show animation:(BOOL)animation;

@end
