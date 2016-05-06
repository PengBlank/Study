//
//  HYConditionSettingViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 筛选的条件设置界面，通用区域位置设置和价格星级
 */

#import "HYHotelViewBaseController.h"
#import "HYHotelCondition.h"

@protocol HYConditionSettingDelegate;
@interface HYConditionSettingViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, assign) id<HYConditionSettingDelegate> delegate;
@property (nonatomic, assign) ConditionType viewType;
@property (nonatomic, strong) HYHotelCondition* condition;

@end


@protocol HYConditionSettingDelegate <NSObject>

@optional
- (void)didSelectCondition:(HYHotelCondition *)condition type:(ConditionType)viewType;

@end