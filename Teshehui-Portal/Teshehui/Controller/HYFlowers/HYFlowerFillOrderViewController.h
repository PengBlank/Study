//
//  HYFlowerFillOrderViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *鲜花订单填写
 */
#import "HYFolwerViewBaseController.h"
#import "HYFlowerDetailInfo.h"

@interface HYFlowerFillOrderViewController : HYFolwerViewBaseController
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate
>

@property (nonatomic, readonly, strong) UITableView *tableView;
@property (nonatomic, strong) HYFlowerDetailInfo *flowerDetailInfo;
@property (nonatomic, assign) NSInteger buyTotal;

@end
