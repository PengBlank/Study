//
//  HYMallFullOrderToolView.h
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  订单填写底部菜单
 */
#import <UIKit/UIKit.h>

@protocol HYMallFullOrderToolViewDelegate <NSObject>

@required
- (void)didCommitOrder;

@end

@interface HYMallFullOrderToolView : UIView

@property (nonatomic, weak) id<HYMallFullOrderToolViewDelegate> delegate;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger point;
@property (nonatomic, assign) BOOL hasExpress;

@end
