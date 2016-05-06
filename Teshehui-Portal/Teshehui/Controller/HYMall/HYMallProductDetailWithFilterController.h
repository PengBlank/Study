//
//  HYProductDetailViewController.h
//  Teshehui
//
//  Created by HYZB on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  产品详情界面
 */
#import "HYMallViewBaseController.h"
#import "RKBasePageViewController.h"
#import "HYProductDetailToolView.h"

@interface HYMallProductDetailWithFilterController : RKPageContentViewController
<
UITableViewDelegate,
UITableViewDataSource,
HYProductDetailToolViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, copy) NSString *goodsId;  //产品的id
@property (nonatomic, assign) BOOL loadFromPayResult;

@property (nonatomic, weak) HYProductDetailToolView *toolView;  //必须为weak。这个地方为临时处理方式。

@end
