//
//  HYMallOrderDetailViewController.h
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  商城订单详情
 */
#import "HYMallViewBaseController.h"
#import "HYMallOrderDetail.h"

@protocol HYMallOrderListHandleDelegate <NSObject>

- (void)updateWithOrder:(HYMallChildOrder *)order type:(MallOrderHandleType)type;

@end

@interface HYMallOrderDetailViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, weak) id<HYMallOrderListHandleDelegate> orderListView;
@property (nonatomic, strong) HYMallChildOrder *orderInfo;

@property (nonatomic, assign) BOOL loadFromPayResult;  //是否从支付结果界面跳转过来的，对应的返回页面不同

@end
