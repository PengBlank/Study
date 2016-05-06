//
//  HYMallFullOrderViewController.h
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  订单确认界面
 */
#import "HYMallViewBaseController.h"

@interface HYMallFullOrderViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) NSArray *storeList;

/// 三个阶梯价计算后所得到的总价
/// 阶梯价后省的钱
@property (nonatomic, strong) NSString *spareAmount;
/// 阶梯价后所需要的钱
@property (nonatomic, strong) NSString *amountAfterSpare;
/// 阶梯价后的现金券
@property (nonatomic, strong) NSString *pointAfterSpare;

@end
