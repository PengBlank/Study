//
//  HYPaymentSuccViewController.h
//  Teshehui
//
//  Created by HYZB on 14/11/19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 支付成功界面
 */

#import "HYCustomNavItemViewController.h"
#import "HYAddressInfo.h"

@interface HYPaymentSuccViewController : HYCustomNavItemViewController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, copy) NSString *goodsId;  //产品的id
@property (nonatomic, copy) NSString *orderCode;  //订单的id
@property (nonatomic, copy) NSString *price;  //
@property (nonatomic, assign) CGFloat point;  //现金券
@property (nonatomic, strong) HYAddressInfo *adressInfo;

@end
