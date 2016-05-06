//
//  HYCardTypeListViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseDetailViewController.h"
#import "HYCardType.h"

typedef enum _CardConditionType
{
    UseForPassenger = 1,
    UseForBuyInsourance
}CardConditionType;

@protocol HYCardTypeListViewControllerDelegate;

@interface HYCardTypeListViewController : HYBaseDetailViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, assign) CardConditionType type;  //显示卡的条件类型，默认是常用旅客
@property (nonatomic, weak) id<HYCardTypeListViewControllerDelegate>delegate;
@property (nonatomic, strong, readonly) UITableView *tableView;

@end


@protocol HYCardTypeListViewControllerDelegate <NSObject>

@optional
- (void)didSelectCardtype:(HYCardType *)card;

@end